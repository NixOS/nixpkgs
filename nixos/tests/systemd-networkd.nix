let generateNodeConf = { lib, pkgs, config, privk, pubk, peerId, nodeId, ...}: {
      imports = [ common/user-account.nix ];
      systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
      networking.useNetworkd = true;
      networking.useDHCP = false;
      networking.firewall.enable = false;
      virtualisation.vlans = [ 1 ];
      environment.systemPackages = with pkgs; [ wireguard-tools ];
      boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
      systemd.tmpfiles.rules = [
        "f /run/wg_priv 0640 root systemd-network - ${privk}"
      ];
      systemd.network = {
        enable = true;
        netdevs = {
          "90-wg0" = {
            netdevConfig = { Kind = "wireguard"; Name = "wg0"; };
            wireguardConfig = {
              PrivateKeyFile = "/run/wg_priv";
              ListenPort = 51820;
              FwMark = 42;
            };
            wireguardPeers = [ {wireguardPeerConfig={
              Endpoint = "192.168.1.${peerId}:51820";
              PublicKey = pubk;
              PresharedKeyFile = pkgs.writeText "psk.key" "yTL3sCOL33Wzi6yCnf9uZQl/Z8laSE+zwpqOHC4HhFU=";
              AllowedIPs = [ "10.0.0.${peerId}/32" ];
              PersistentKeepalive = 15;
            };}];
          };
        };
        networks = {
          "99-nope" = {
            matchConfig.Name = "eth*";
            linkConfig.Unmanaged = true;
          };
          "90-wg0" = {
            matchConfig = { Name = "wg0"; };
            address = [ "10.0.0.${nodeId}/32" ];
            routes = [
              { routeConfig = { Gateway = "10.0.0.${nodeId}"; Destination = "10.0.0.0/24"; }; }
            ];
          };
          "30-eth1" = {
            matchConfig = { Name = "eth1"; };
            address = [
              "192.168.1.${nodeId}/24"
              "fe80::${nodeId}/64"
            ];
            routingPolicyRules = [
              { routingPolicyRuleConfig = { Table = 10; IncomingInterface = "eth1"; Family = "both"; };}
              { routingPolicyRuleConfig = { Table = 20; OutgoingInterface = "eth1"; };}
              { routingPolicyRuleConfig = { Table = 30; From = "192.168.1.1"; To = "192.168.1.2"; SourcePort = 666 ; DestinationPort = 667; };}
              { routingPolicyRuleConfig = { Table = 40; IPProtocol = "tcp"; InvertRule = true; };}
              { routingPolicyRuleConfig = { Table = 50; IncomingInterface = "eth1"; Family = "ipv4"; };}
            ];
          };
        };
      };
    };
in import ./make-test-python.nix ({pkgs, ... }: {
  name = "networkd";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ninjatrappeur ];
  };
  nodes = {
    node1 = { pkgs, ... }@attrs:
    let localConf = {
        privk = "GDiXWlMQKb379XthwX0haAbK6hTdjblllpjGX0heP00=";
        pubk = "iRxpqj42nnY0Qz8MAQbSm7bXxXP5hkPqWYIULmvW+EE=";
        nodeId = "1";
        peerId = "2";
    };
    in generateNodeConf (attrs // localConf);

    node2 = { pkgs, ... }@attrs:
    let localConf = {
        privk = "eHxSI2jwX/P4AOI0r8YppPw0+4NZnjOxfbS5mt06K2k=";
        pubk = "27s0OvaBBdHoJYkH9osZpjpgSOVNw+RaKfboT/Sfq0g=";
        nodeId = "2";
        peerId = "1";
    };
    in generateNodeConf (attrs // localConf);
  };
testScript = ''
    start_all()
    node1.wait_for_unit("systemd-networkd-wait-online.service")
    node2.wait_for_unit("systemd-networkd-wait-online.service")

    # ================================
    # Wireguard
    # ================================
    node1.succeed("ping -c 5 10.0.0.2")
    node2.succeed("ping -c 5 10.0.0.1")
    # Is the fwmark set?
    node2.succeed("wg | grep -q 42")

    # ================================
    # Routing Policies
    # ================================
    # Testing all the routingPolicyRuleConfig members:
    # Table + IncomingInterface
    node1.succeed("sudo ip rule | grep 'from all iif eth1 lookup 10'")
    # OutgoingInterface
    node1.succeed("sudo ip rule | grep 'from all oif eth1 lookup 20'")
    # From + To + SourcePort + DestinationPort
    node1.succeed(
        "sudo ip rule | grep 'from 192.168.1.1 to 192.168.1.2 sport 666 dport 667 lookup 30'"
    )
    # IPProtocol + InvertRule
    node1.succeed("sudo ip rule | grep 'not from all ipproto tcp lookup 40'")
'';
})
