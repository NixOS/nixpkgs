{ lib, pkgs, ... }:
{
  name = "3proxy";
  meta.maintainers = with lib.maintainers; [ misuzu ];

  nodes = {
    peer0 =
      { lib, ... }:
      {
        networking.useDHCP = false;
        networking.interfaces.eth1 = {
          ipv4.addresses = [
            {
              address = "192.168.0.1";
              prefixLength = 24;
            }
            {
              address = "216.58.211.111";
              prefixLength = 24;
            }
          ];
        };
      };

    peer1 =
      { lib, ... }:
      {
        networking.useDHCP = false;
        networking.interfaces.eth1 = {
          ipv4.addresses = [
            {
              address = "192.168.0.2";
              prefixLength = 24;
            }
            {
              address = "216.58.211.112";
              prefixLength = 24;
            }
          ];
        };
        # test that binding to [::] is working when ipv6 is disabled
        networking.enableIPv6 = false;
        services._3proxy = {
          enable = true;
          services = [
            {
              type = "admin";
              bindPort = 9999;
              auth = [ "none" ];
            }
            {
              type = "proxy";
              bindPort = 3128;
              auth = [ "none" ];
            }
          ];
        };
        networking.firewall.allowedTCPPorts = [
          3128
          9999
        ];
      };

    peer2 =
      { lib, ... }:
      {
        networking.useDHCP = false;
        networking.interfaces.eth1 = {
          ipv4.addresses = [
            {
              address = "192.168.0.3";
              prefixLength = 24;
            }
            {
              address = "216.58.211.113";
              prefixLength = 24;
            }
          ];
        };
        services._3proxy = {
          enable = true;
          services = [
            {
              type = "admin";
              bindPort = 9999;
              auth = [ "none" ];
            }
            {
              type = "proxy";
              bindPort = 3128;
              auth = [ "iponly" ];
              acl = [
                {
                  rule = "allow";
                }
              ];
            }
          ];
        };
        networking.firewall.allowedTCPPorts = [
          3128
          9999
        ];
      };

    peer3 =
      { lib, pkgs, ... }:
      {
        networking.useDHCP = false;
        networking.interfaces.eth1 = {
          ipv4.addresses = [
            {
              address = "192.168.0.4";
              prefixLength = 24;
            }
            {
              address = "216.58.211.114";
              prefixLength = 24;
            }
          ];
        };
        services._3proxy = {
          enable = true;
          usersFile = pkgs.writeText "3proxy.passwd" ''
            admin:CR:$1$.GUV4Wvk$WnEVQtaqutD9.beO5ar1W/
          '';
          services = [
            {
              type = "admin";
              bindPort = 9999;
              auth = [ "none" ];
            }
            {
              type = "proxy";
              bindPort = 3128;
              auth = [ "strong" ];
              acl = [
                {
                  rule = "allow";
                }
              ];
            }
          ];
        };
        networking.firewall.allowedTCPPorts = [
          3128
          9999
        ];
      };
  };

  testScript = ''
    start_all()

    peer0.systemctl("start network-online.target")
    peer0.wait_for_unit("network-online.target")

    peer1.wait_for_unit("3proxy.service")
    peer1.wait_for_open_port(9999)

    # test none auth
    peer0.succeed(
        "${pkgs.wget}/bin/wget -e use_proxy=yes -e http_proxy=http://192.168.0.2:3128 -S -O /dev/null http://216.58.211.112:9999"
    )
    peer0.succeed(
        "${pkgs.wget}/bin/wget -e use_proxy=yes -e http_proxy=http://192.168.0.2:3128 -S -O /dev/null http://192.168.0.2:9999"
    )
    peer0.succeed(
        "${pkgs.wget}/bin/wget -e use_proxy=yes -e http_proxy=http://192.168.0.2:3128 -S -O /dev/null http://127.0.0.1:9999"
    )

    peer2.wait_for_unit("3proxy.service")
    peer2.wait_for_open_port(9999)

    # test iponly auth
    peer0.succeed(
        "${pkgs.wget}/bin/wget -e use_proxy=yes -e http_proxy=http://192.168.0.3:3128 -S -O /dev/null http://216.58.211.113:9999"
    )
    peer0.fail(
        "${pkgs.wget}/bin/wget -e use_proxy=yes -e http_proxy=http://192.168.0.3:3128 -S -O /dev/null http://192.168.0.3:9999"
    )
    peer0.fail(
        "${pkgs.wget}/bin/wget -e use_proxy=yes -e http_proxy=http://192.168.0.3:3128 -S -O /dev/null http://127.0.0.1:9999"
    )

    peer3.wait_for_unit("3proxy.service")
    peer3.wait_for_open_port(9999)

    # test strong auth
    peer0.succeed(
        "${pkgs.wget}/bin/wget -e use_proxy=yes -e http_proxy=http://admin:bigsecret\@192.168.0.4:3128 -S -O /dev/null http://216.58.211.114:9999"
    )
    peer0.fail(
        "${pkgs.wget}/bin/wget -e use_proxy=yes -e http_proxy=http://admin:bigsecret\@192.168.0.4:3128 -S -O /dev/null http://192.168.0.4:9999"
    )
    peer0.fail(
        "${pkgs.wget}/bin/wget -e use_proxy=yes -e http_proxy=http://192.168.0.4:3128 -S -O /dev/null http://216.58.211.114:9999"
    )
    peer0.fail(
        "${pkgs.wget}/bin/wget -e use_proxy=yes -e http_proxy=http://192.168.0.4:3128 -S -O /dev/null http://192.168.0.4:9999"
    )
    peer0.fail(
        "${pkgs.wget}/bin/wget -e use_proxy=yes -e http_proxy=http://192.168.0.4:3128 -S -O /dev/null http://127.0.0.1:9999"
    )
  '';
}
