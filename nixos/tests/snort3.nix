import ./make-test-python.nix
  (
    { lib, pkgs, ... }:
    {
      name = "snort3";

      meta = with lib.maintainers; {
        maintainers = [ zzschmidc ];
      };

      # Test scenarios:
      #   1. Snort as IDS to detect on ICMP packets to the 'homeNet'. Only alert on ICMP packets.
      #   2. Snort as IPS to detect and reject ICMP packets to the 'homeNet'. Alert and reject packets.

      nodes = {
        client1 = {
          # WAN
          virtualisation.vlans = [ 1 ];

          networking = {
            useDHCP = false;
            firewall.enable = false;
            interfaces.eth1 = {
              ipv4.addresses = lib.mkForce [ ];
              ipv6.addresses = lib.mkForce [
                { address = "2001:db8:0:a::2"; prefixLength = 64; }
              ];
            };
            defaultGateway6 = {
              address = "2001:db8:0:a::1";
              interface = "eth1";
            };
          };
        };

        client2 = {
          # LAN
          virtualisation.vlans = [ 2 ];

          networking = {
            useDHCP = false;
            firewall.enable = false;
            interfaces.eth1 = {
              ipv4.addresses = lib.mkForce [ ];
              ipv6.addresses = lib.mkForce [
                { address = "2001:db8:0:b::2"; prefixLength = 64; }
              ];
            };
            defaultGateway6 = {
              address = "2001:db8:0:b::1";
              interface = "eth1";
            };
          };
        };

        gateway = { lib, ... }:
          let
            extraFlags = [ "-s 65535" "-k none" "-M" "-A alert_fast" "--warn-all" ];

            extraConfigText = {
              passiveMode = ''
                ips =
                {
                  enable_builtin_rules = false,
                  include = RULE_PATH .. "/snort.rules",
                  variables = default_variables
                }
              '';
              inlineMode = ''
                ips =
                {
                  mode = inline,
                  enable_builtin_rules = false,
                  include = RULE_PATH .. "/snort.rules",
                  variables = default_variables
                }
              '';
              default = ''
                alert_fast = { file = false, packet = false }
                -- packet_tracer = { enable = true }
              '';
            };
          in
          {
            virtualisation.vlans = [ 1 2 ];

            boot.kernel.sysctl = {
              "net.ipv6.conf.all.forwarding" = 1;
            };

            networking = {
              useDHCP = false;
              firewall.enable = false;
              interfaces.eth1 = {
                # WAN
                ipv4.addresses = lib.mkForce [ ];
                ipv6.addresses = lib.mkForce [
                  { address = "2001:db8:0:a::1"; prefixLength = 64; }
                ];
              };
              interfaces.eth2 = {
                # LAN
                ipv4.addresses = lib.mkForce [ ];
                ipv6.addresses = lib.mkForce [
                  { address = "2001:db8:0:b::1"; prefixLength = 64; }
                ];
              };
            };

            services.snort3 = {
              enable = false; # start disabled
              dataDir = "/var/lib/snort3";

              # We protect 'client2' via eth2 (LAN)
              homeNet = [ "2001:db8:0:b::2/128" ];

              netInterfaces = [ "eth1" ]; # WAN interface
            };

            # Override to conduct the 1st test in 'passive' mode.
            specialisation.passiveMode.configuration = {
              services.snort3 = lib.mapAttrs (lib.const lib.mkForce) {
                enable = true;
                inherit extraFlags;
                daqType = "afpacket";
                daqMode = "passive";
                extraConfigText = ''
                  ${extraConfigText.passiveMode}
                  ${extraConfigText.default}
                '';
              };
            };

            # Override to conduct the 2nd test in 'inline' mode.
            specialisation.inlineMode.configuration = {
              services.snort3 = lib.mapAttrs (lib.const lib.mkForce) {
                enable = true;
                extraFlags = (extraFlags ++ [ "-Q" ]);
                daqType = "nfq";
                daqMode = "inline";
                daqVars = [ "buffer_size_mb=128" ];
                netInterfaces = [ "42" ]; # no iface, but nfqueue
                extraConfigText = ''
                  ${extraConfigText.inlineMode}
                  ${extraConfigText.default}
                '';
              };

              networking.firewall = lib.mkForce {
                enable = true;
                extraCommands = ''
                  # Pass traffic if Snort is not listing to NFQ by 'queue-bypass'.
                  ip6tables -I FORWARD -i eth1 -o eth2 -j NFQUEUE --queue-num 42 --queue-bypass
                '';
              };
            };
          };
      };

      testScript = { nodes, ... }:
        let
          passiveModeSystem = "${nodes.gateway.config.system.build.toplevel}/specialisation/passiveMode";
          inlineModeSystem = "${nodes.gateway.config.system.build.toplevel}/specialisation/inlineMode";

          snortRulesFile = pkgs.writeText "snort.rules" ''
            alert icmp $EXTERNAL_NET any -> $HOME_NET any ( msg:"PROTOCOL-ICMP ICMPv6 Echo Request"; icode:0; itype:128; classtype:icmp-event; sid:4000001; rev:1; )
          '';
        in
        ''
          start_all()

          with subtest("Wait for networking to be configured"):
            gateway.wait_for_unit("network.target")
            client1.wait_for_unit("network.target")
            client2.wait_for_unit("network.target")

            # Print diagnostic information
            client1.succeed("ip -6 addr >&2 && ip -6 route >&2")
            client2.succeed("ip -6 addr >&2 && ip -6 route >&2")

            with subtest("Verify that networking works as configured"):
              # The connection goes via 'gateway'.
              client1.wait_until_succeeds("ping -6 -c 1 2001:db8:0:b::2 >&2")
              client2.wait_until_succeeds("ping -6 -c 1 2001:db8:0:a::2 >&2")

          #
          # Test 1.
          #

          with subtest("Snort - Start in 'passive' mode"):
            gateway.succeed("${passiveModeSystem}/bin/switch-to-configuration test >&2")
            gateway.wait_for_unit("snort3")

            with subtest("Snort - Service is running"):
              gateway.wait_until_succeeds("journalctl -u snort3 -e | grep -q -i 'successfully validated'")
              gateway.wait_until_succeeds("journalctl -u snort3 -e | grep -q -i 'afpacket DAQ configured to passive'")

              with subtest("Snort - Custom logger is loaded"):
                gateway.wait_until_succeeds("journalctl -u snort3 -e | grep -q -i 'alert_fast'")

              with subtest("Snort - No rules are present"):
                gateway.wait_until_fails("journalctl -u snort3 -e | grep -q -i 'text rules: 1'")

              with subtest("Snort - Add rules to the configuration"):
                gateway.succeed("cp ${snortRulesFile} /var/lib/snort3/rules/snort.rules")
                gateway.succeed("cat /var/lib/snort3/rules/snort.rules >&2")

                ## Test service 'reload'
                with subtest("Snort - Service is reloaded"):
                  gateway.systemctl("reload snort3")
                  gateway.wait_until_succeeds("journalctl -u snort3 -e | grep -q -i 'reload complete'")

                with subtest("Snort - Rules are loaded"):
                  gateway.wait_until_succeeds("journalctl -u snort3 -e | grep -q -i 'text rules: 1'")

            ## Detection => alert on packets
            with subtest("Snort - Detection and alerting works"):
              client1.succeed("ping -6 -c 5 2001:db8:0:b::2 >&2")
              gateway.wait_until_succeeds("journalctl -u snort3 -e | grep -q -i '4000001'")

          ## Test service 'stop'
          with subtest("Snort - Service is stopped"):
            gateway.systemctl("stop snort3")
            gateway.wait_until_succeeds("journalctl -u snort3 -e | grep -q -i 'Snort exiting'")

          #
          # Test 2.
          #

          # The rules need to be adjusted to 'reject' packets based on them
          gateway.succeed("sed -i 's/alert/reject/' /var/lib/snort3/rules/snort.rules")
          gateway.succeed("cat /var/lib/snort3/rules/snort.rules >&2")

          with subtest("Snort - Start in 'inline' mode"):
            gateway.succeed("${inlineModeSystem}/bin/switch-to-configuration test >&2")
            gateway.wait_for_unit("snort3")
            gateway.wait_for_unit("firewall")

            # Print diagnostic information
            gateway.succeed("ip6tables -L >&2")

            with subtest("Snort - Service is running"):
              gateway.wait_until_succeeds("journalctl -u snort3 -e | grep -q -i 'successfully validated'")
              gateway.wait_until_succeeds("journalctl -u snort3 -e | grep -q -i 'nfq DAQ configured to inline'")

              with subtest("Snort - Rules are loaded"):
                gateway.wait_until_succeeds("journalctl -u snort3 -e | grep -q -i 'text rules: 1'")

              with subtest("Snort - Custom logger is loaded"):
                gateway.wait_until_succeeds("journalctl -u snort3 -e | grep -q -i 'alert_fast'")

            ## Prevention => reject packets
            with subtest("Snort - Detection and rejection works"):
              client1.fail("ping -6 -c 5 2001:db8:0:b::2 >&2")
              gateway.wait_until_succeeds("journalctl -u snort3 -e | grep -q -i '4000001'")

          ## Test service 'stop'
          with subtest("Snort - Service is stopped"):
            gateway.systemctl("stop snort3")
            gateway.wait_until_succeeds("journalctl -u snort3 -e | grep -q -i 'Snort exiting'")
        '';
    }
  )
