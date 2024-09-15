# This test verifies that we can request and assign IPv6 prefixes from upstream
# (e.g. ISP) routers.
# The setup consists of three VMs. One for the ISP, as your residential router
# and the third as a client machine in the residential network.
#
# There are two VLANs in this test:
# - VLAN 1 is the connection between the ISP and the router
# - VLAN 2 is the connection between the router and the client

import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "systemd-networkd-ipv6-prefix-delegation";
  meta = with lib.maintainers; {
    maintainers = [ andir hexa ];
  };
  nodes = {

    # The ISP's routers job is to delegate IPv6 prefixes via DHCPv6. Like with
    # regular IPv6 auto-configuration it will also emit IPv6 router
    # advertisements (RAs). Those RA's will not carry a prefix but in contrast
    # just set the "Other" flag to indicate to the receiving nodes that they
    # should attempt DHCPv6.
    #
    # Note: On the ISPs device we don't really care if we are using networkd in
    # this example. That being said we can't use it (yet) as networkd doesn't
    # implement the serving side of DHCPv6. We will use ISC Kea for that task.
    isp = { lib, pkgs, ... }: {
      virtualisation.vlans = [ 1 ];
      networking = {
        useDHCP = false;
        firewall.enable = false;
        interfaces.eth1 = lib.mkForce {}; # Don't use scripted networking
      };

      systemd.network = {
        enable = true;

        networks = {
          "eth1" = {
            matchConfig.Name = "eth1";
            address = [
              "2001:DB8::1/64"
            ];
            networkConfig.IPv4Forwarding = true;
            networkConfig.IPv6Forwarding = true;
          };
        };
      };

      # Since we want to program the routes that we delegate to the "customer"
      # into our routing table we must provide kea with the required capability.
      systemd.services.kea-dhcp6-server.serviceConfig = {
        AmbientCapabilities = [ "CAP_NET_ADMIN" ];
        CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
      };

      services = {
        # Configure the DHCPv6 server to hand out both IA_NA and IA_PD.
        #
        # We will hand out /48 prefixes from the subnet 2001:DB8:F000::/36.
        # That gives us ~8k prefixes. That should be enough for this test.
        #
        # Since (usually) you will not receive a prefix with the router
        # advertisements we also hand out /128 leases from the range
        # 2001:DB8:0000:0000:FFFF::/112.
        kea.dhcp6 = {
          enable = true;
          settings = {
            interfaces-config.interfaces = [ "eth1" ];
            subnet6 = [ {
              id = 1;
              interface = "eth1";
              subnet = "2001:DB8::/32";
              pd-pools = [ {
                prefix = "2001:DB8:1000::";
                prefix-len = 36;
                delegated-len = 48;
              } ];
              pools = [ {
                pool = "2001:DB8:0000:0000::-2001:DB8:0FFF:FFFF::FFFF";
              } ];
            } ];

            # This is the glue between Kea and the Kernel FIB. DHCPv6
            # rightfully has no concept of setting up a route in your
            # FIB. This step really depends on your setup.
            #
            # In a production environment your DHCPv6 server is likely
            # not the router. You might want to consider BGP, NETCONF
            # calls, … in those cases.
            #
            # In this example we use the run script hook, that lets use
            # execute anything and passes information via the environment.
            # https://kea.readthedocs.io/en/kea-2.2.0/arm/hooks.html#run-script-run-script-support-for-external-hook-scripts
            hooks-libraries = [ {
              library = "${pkgs.kea}/lib/kea/hooks/libdhcp_run_script.so";
              parameters = {
                name = pkgs.writeShellScript "kea-run-hooks" ''
                  export PATH="${lib.makeBinPath (with pkgs; [ coreutils iproute2 ])}"

                  set -euxo pipefail

                  leases6_committed() {
                    for i in $(seq $LEASES6_SIZE); do
                      idx=$((i-1))
                      prefix_var="LEASES6_AT''${idx}_ADDRESS"
                      plen_var="LEASES6_AT''${idx}_PREFIX_LEN"

                      ip -6 route replace ''${!prefix_var}/''${!plen_var} via $QUERY6_REMOTE_ADDR dev $QUERY6_IFACE_NAME
                    done
                  }

                  unknown_handler() {
                    echo "Unhandled function call ''${*}"
                    exit 123
                  }

                  case "$1" in
                      "leases6_committed")
                          leases6_committed
                          ;;
                      *)
                          unknown_handler "''${@}"
                          ;;
                  esac
                '';
                sync = false;
              };
            } ];
          };
        };

        # Finally we have to set up the router advertisements. While we could be
        # using networkd or bird for this task `radvd` is probably the most
        # venerable of them all. It was made explicitly for this purpose and
        # the configuration is much more straightforward than what networkd
        # requires.
        # As outlined above we will have to set the `Managed` flag as otherwise
        # the clients will not know if they should do DHCPv6. (Some do
        # anyway/always)
        radvd = {
          enable = true;
          config = ''
            interface eth1 {
              AdvSendAdvert on;
              AdvManagedFlag on;
              AdvOtherConfigFlag off; # we don't really have DNS or NTP or anything like that to distribute
              prefix ::/64 {
                AdvOnLink on;
                AdvAutonomous on;
              };
            };
          '';
        };

      };
    };

    # This will be our (residential) router that receives the IPv6 prefix (IA_PD)
    # and /128 (IA_NA) allocation.
    #
    # Here we will actually start using networkd.
    router = {
      virtualisation.vlans = [ 1 2 ];
      systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";

      boot.kernel.sysctl = {
        # we want to forward packets from the ISP to the client and back.
        "net.ipv6.conf.all.forwarding" = 1;
      };

      networking = {
        useNetworkd = true;
        useDHCP = false;
        # Consider enabling this in production and generating firewall rules
        # for fowarding/input from the configured interfaces so you do not have
        # to manage multiple places
        firewall.enable = false;
        interfaces.eth1.ipv6.addresses = lib.mkForce [ ];
      };

      systemd.network = {
        networks = {
          # systemd-networkd will load the first network unit file
          # that matches, ordered lexiographically by filename.
          # /etc/systemd/network/{40-eth1,99-main}.network already
          # exists. This network unit must be loaded for the test,
          # however, hence why this network is named such.

          # Configuration of the interface to the ISP.
          # We must request accept RAs and request the PD prefix.
          "01-eth1" = {
            name = "eth1";
            networkConfig = {
              Description = "ISP interface";
              IPv6AcceptRA = true;
              #DHCP = false; # no need for legacy IP
            };
            linkConfig = {
              # We care about this interface when talking about being "online".
              # If this interface is in the `routable` state we can reach
              # others and they should be able to reach us.
              RequiredForOnline = "routable";
            };
            # This configures the DHCPv6 client part towards the ISPs DHCPv6 server.
            dhcpV6Config = {
              # We have to include a request for a prefix in our DHCPv6 client
              # request packets.
              # Otherwise the upstream DHCPv6 server wouldn't know if we want a
              # prefix or not.  Note: On some installation it makes sense to
              # always force that option on the DHPCv6 server since there are
              # certain CPEs that are just not setting this field but happily
              # accept the delegated prefix.
              PrefixDelegationHint  = "::/48";
            };
            ipv6SendRAConfig = {
              # Let networkd know that we would very much like to use DHCPv6
              # to obtain the "managed" information. Not sure why they can't
              # just take that from the upstream RAs.
              Managed = true;
            };
          };

          # Interface to the client. Here we should redistribute a /64 from
          # the prefix we received from the ISP.
          "01-eth2" = {
            name = "eth2";
            networkConfig = {
              Description = "Client interface";
              # The client shouldn't be allowed to send us RAs, that would be weird.
              IPv6AcceptRA = false;

              # Delegate prefixes from the DHCPv6 PD pool.
              DHCPPrefixDelegation = true;
              IPv6SendRA = true;
            };

            # In a production environment you should consider setting these as well:
            # ipv6SendRAConfig = {
              #EmitDNS = true;
              #EmitDomains = true;
              #DNS= = "fe80::1"; # or whatever "well known" IP your router will have on the inside.
            # };

            # This adds a "random" ULA prefix to the interface that is being
            # advertised to the clients.
            # Not used in this test.
            # ipv6Prefixes = [
            #   {
            #     ipv6PrefixConfig = {
            #       AddressAutoconfiguration = true;
            #       PreferredLifetimeSec = 1800;
            #       ValidLifetimeSec = 1800;
            #     };
            #   }
            # ];
          };

          # finally we are going to add a static IPv6 unique local address to
          # the "lo" interface.  This will serve as ICMPv6 echo target to
          # verify connectivity from the client to the router.
          "01-lo" = {
            name = "lo";
            addresses = [
              { Address = "FD42::1/128"; }
            ];
          };
        };
      };
    };

    # This is the client behind the router. We should be receiving router
    # advertisements for both the ULA and the delegated prefix.
    # All we have to do is boot with the default (networkd) configuration.
    client = {
      virtualisation.vlans = [ 2 ];
      systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
      networking = {
        useNetworkd = true;
        useDHCP = false;
        interfaces.eth1.ipv6.addresses = lib.mkForce [ ];
      };
    };
  };

  testScript = ''
    # First start the router and wait for it it reach a state where we are
    # certain networkd is up and it is able to send out RAs
    router.start()
    router.wait_for_unit("systemd-networkd.service")

    # After that we can boot the client and wait for the network online target.
    # Since we only care about IPv6 that should not involve waiting for legacy
    # IP leases.
    client.start()
    client.systemctl("start network-online.target")
    client.wait_for_unit("network-online.target")

    # the static address on the router should not be reachable
    client.wait_until_succeeds("ping -6 -c 1 FD42::1")

    # the global IP of the ISP router should still not be a reachable
    router.fail("ping -6 -c 1 2001:DB8::1")

    # Once we have internal connectivity boot up the ISP
    isp.start()

    # Since for the ISP "being online" should have no real meaning we just
    # wait for the target where all the units have been started.
    # It probably still takes a few more seconds for all the RA timers to be
    # fired etc..
    isp.wait_for_unit("multi-user.target")

    # wait until the uplink interface has a good status
    router.systemctl("start network-online.target")
    router.wait_for_unit("network-online.target")
    router.wait_until_succeeds("ping -6 -c1 2001:DB8::1")

    # shortly after that the client should have received it's global IPv6
    # address and thus be able to ping the ISP
    client.wait_until_succeeds("ping -6 -c1 2001:DB8::1")

    # verify that we got a globally scoped address in eth1 from the
    # documentation prefix
    ip_output = client.succeed("ip --json -6 address show dev eth1")

    import json

    ip_json = json.loads(ip_output)[0]
    assert any(
        addr["local"].upper().startswith("2001:DB8:")
        for addr in ip_json["addr_info"]
        if addr["scope"] == "global"
    )
  '';
})
