import ../make-test-python.nix ({ lib, ... }:
  let
    snakeoil-keys = import ./snakeoil-keys.nix;

    hosts = lib.attrNames snakeoil-keys;

    subnetOf = name: config:
      let
        subnets = config.services.tinc.networks.myNetwork.hostSettings.${name}.subnets;
      in
      (builtins.head subnets).address;

    makeTincHost = name: { subnet, extraConfig ? { } }: lib.mkMerge [
      {
        subnets = [{ address = subnet; }];
        settings = {
          Ed25519PublicKey = snakeoil-keys.${name}.ed25519Public;
        };
        rsaPublicKey = snakeoil-keys.${name}.rsaPublic;
      }
      extraConfig
    ];

    makeTincNode = { config, ... }: name: extraConfig: lib.mkMerge [
      {
        services.tinc.networks.myNetwork = {
          inherit name;
          rsaPrivateKeyFile =
            builtins.toFile "rsa.priv" snakeoil-keys.${name}.rsaPrivate;
          ed25519PrivateKeyFile =
            builtins.toFile "ed25519.priv" snakeoil-keys.${name}.ed25519Private;

          hostSettings = lib.mapAttrs makeTincHost {
            static = {
              subnet = "10.0.0.11";
              # Only specify the addresses in the node's vlans, Tinc does not
              # seem to try each one, unlike the documentation suggests...
              extraConfig.addresses = map
                (vlan: { address = "192.168.${toString vlan}.11"; port = 655; })
                config.virtualisation.vlans;
            };
            dynamic1 = { subnet = "10.0.0.21"; };
            dynamic2 = { subnet = "10.0.0.22"; };
          };
        };

        networking.useDHCP = false;

        networking.interfaces."tinc.myNetwork" = {
          virtual = true;
          virtualType = "tun";
          ipv4.addresses = [{
            address = subnetOf name config;
            prefixLength = 24;
          }];
        };

        # Prevents race condition between NixOS service and tinc creating the
        # interface.
        # See: https://github.com/NixOS/nixpkgs/issues/27070
        systemd.services."tinc.myNetwork" = {
          after = [ "network-addresses-tinc.myNetwork.service" ];
          requires = [ "network-addresses-tinc.myNetwork.service" ];
        };

        networking.firewall.allowedTCPPorts = [ 655 ];
        networking.firewall.allowedUDPPorts = [ 655 ];
      }
      extraConfig
    ];

  in
  {
    name = "tinc";
    meta.maintainers = with lib.maintainers; [ minijackson ];

    nodes = {

      static = { ... } @ args:
        makeTincNode args "static" {
          virtualisation.vlans = [ 1 2 ];

          networking.interfaces.eth1.ipv4.addresses = [{
            address = "192.168.1.11";
            prefixLength = 24;
          }];

          networking.interfaces.eth2.ipv4.addresses = [{
            address = "192.168.2.11";
            prefixLength = 24;
          }];
        };


      dynamic1 = { ... } @ args:
        makeTincNode args "dynamic1" {
          virtualisation.vlans = [ 1 ];
        };

      dynamic2 = { ... } @ args:
        makeTincNode args "dynamic2" {
          virtualisation.vlans = [ 2 ];
        };

    };

    testScript = ''
      start_all()

      static.wait_for_unit("tinc.myNetwork.service")
      dynamic1.wait_for_unit("tinc.myNetwork.service")
      dynamic2.wait_for_unit("tinc.myNetwork.service")

      # Static is accessible by the other hosts
      dynamic1.succeed("ping -c5 192.168.1.11")
      dynamic2.succeed("ping -c5 192.168.2.11")

      # The other hosts are in separate vlans
      dynamic1.fail("ping -c5 192.168.2.11")
      dynamic2.fail("ping -c5 192.168.1.11")

      # Each host can ping themselves through Tinc
      static.succeed("ping -c5 10.0.0.11")
      dynamic1.succeed("ping -c5 10.0.0.21")
      dynamic2.succeed("ping -c5 10.0.0.22")

      # Static is accessible by the other hosts through Tinc
      dynamic1.succeed("ping -c5 10.0.0.11")
      dynamic2.succeed("ping -c5 10.0.0.11")

      # Static can access the other hosts through Tinc
      static.succeed("ping -c5 10.0.0.21")
      static.succeed("ping -c5 10.0.0.22")

      # The other hosts in separate vlans can access each other through Tinc
      dynamic1.succeed("ping -c5 10.0.0.22")
      dynamic2.succeed("ping -c5 10.0.0.21")
    '';
  })
