{ package }:
import ../make-test-python.nix (
  { pkgs, lib, ... }:
  let
    hosts = {
      a = {
        ip = "192.168.1.1";
        subnet = "192.168.11.0/24";
        tunnelIp = "192.168.11.1";
      };
      b = {
        ip = "192.168.1.2";
        subnet = "192.168.12.0/24";
        tunnelIp = "192.168.12.1";
      };
    };

    ipUpDownScript = host: rec {
      storePath = pkgs.writeShellScript "strongswan-updown.sh" ''
        set +e

        case "$PLUTO_VERB" in
            up-client)
                ip link add test type dummy
                ip addr add ${host.tunnelIp}/32 dev test
                ip link set up dev test
                ;;
        esac
      '';
      shortEtcPath = "strongswan/strongswan-updown.sh";
      fullEtcPath = "/etc/${shortEtcPath}";
    };

    conn = left: right: {
      auto = "start";
      leftupdown = (ipUpDownScript left).fullEtcPath;
      left = left.ip;
      leftsubnet = left.subnet;
      right = right.ip;
      rightsubnet = right.subnet;
      authby = "secret";
      type = "tunnel";
      keyexchange = "ikev2";
      dpdaction = "restart";
    };

    mkNode =
      name:
      { pkgs, ... }:
      let
        me = hosts.${name};
        other = if name == "a" then hosts.b else hosts.a;
        myIfUpDownScript = ipUpDownScript me;
        allowESP = "iptables --insert INPUT --protocol ESP --jump ACCEPT";
      in
      {
        environment.systemPackages = with pkgs; [
          iproute2
        ];

        networking.firewall = {
          allowedUDPPorts = [
            4500
            500
          ];
          extraCommands = allowESP;
        };

        networking.useDHCP = false;
        networking.interfaces.eth0.useDHCP = true;
        networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
          {
            address = me.ip;
            prefixLength = 24;
          }
        ];

        environment.etc.${myIfUpDownScript.shortEtcPath} = {
          source = myIfUpDownScript.storePath;
          mode = "0755";
        };

        services.strongswan = {
          enable = true;
          inherit package;
          connections.test = conn me other;
          secrets = [
            (toString (pkgs.writeText "test.secrets" "${other.ip} : PSK NixpZAZqEN6Ti9sqt4ZP5EWcqx"))
          ];
        };
      };
  in
  {
    name = "strongswan";
    meta.maintainers = [ lib.maintainers.johanot ];

    nodes = {
      nodeA = mkNode "a";
      nodeB = mkNode "b";
    };

    testScript = ''
      start_all()

      nodeA.wait_until_succeeds("ping -c 1 ${hosts.b.tunnelIp}")
      nodeB.wait_until_succeeds("ping -c 1 ${hosts.a.tunnelIp}")
    '';
  }
)
