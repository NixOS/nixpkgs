let generateNodeConf = { lib, pkgs, config, privkpath, pubk, peerId, nodeId, ...}: {
      imports = [ common/user-account.nix ];
      systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
      networking.useNetworkd = true;
      networking.useDHCP = false;
      networking.firewall.enable = false;
      virtualisation.vlans = [ 1 ];
      environment.systemPackages = with pkgs; [ wireguard-tools ];
      boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
      systemd.network = {
        enable = true;
        netdevs = {
          "90-wg0" = {
            netdevConfig = { Kind = "wireguard"; Name = "wg0"; };
            wireguardConfig = {
              PrivateKeyFile = privkpath ;
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
          "90-eth1" = {
            matchConfig = { Name = "eth1"; };
            address = [ "192.168.1.${nodeId}/24" ];
          };
        };
      };
    };
in import ./make-test.nix ({pkgs, ... }: {
  name = "networkd-wireguard";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ninjatrappeur ];
  };
  nodes = {
    node1 = { pkgs, ... }@attrs:
    let localConf = {
        privkpath = pkgs.writeText "priv.key" "GDiXWlMQKb379XthwX0haAbK6hTdjblllpjGX0heP00=";
        pubk = "iRxpqj42nnY0Qz8MAQbSm7bXxXP5hkPqWYIULmvW+EE=";
        nodeId = "1";
        peerId = "2";
    };
    in generateNodeConf (attrs // localConf);

    node2 = { pkgs, ... }@attrs:
    let localConf = {
        privkpath = pkgs.writeText "priv.key" "eHxSI2jwX/P4AOI0r8YppPw0+4NZnjOxfbS5mt06K2k=";
        pubk = "27s0OvaBBdHoJYkH9osZpjpgSOVNw+RaKfboT/Sfq0g=";
        nodeId = "2";
        peerId = "1";
    };
    in generateNodeConf (attrs // localConf);
  };
testScript = ''
    startAll;
    $node1->waitForUnit('systemd-networkd-wait-online.service');
    $node2->waitForUnit('systemd-networkd-wait-online.service');
    $node1->succeed('ping -c 5 10.0.0.2');
    $node2->succeed('ping -c 5 10.0.0.1');
    # Is the fwmark set?
    $node2->succeed('wg | grep -q 42');
'';
})
