# implements https://github.com/scionproto/scion/blob/27983125bccac6b84d1f96f406853aab0e460405/doc/tutorials/deploy.rst
import ../../make-test-python.nix ({ pkgs, ... }:
let
  trust-root-configuration-keys = pkgs.runCommand "generate-trc-keys.sh" {
    buildInputs = [
      pkgs.scion
    ];
  } (builtins.readFile ./bootstrap.sh);

  imports = hostId: [
    ({
      services.scion = {
        enable = true;
        bypassBootstrapWarning = true;
      };
      networking = {
        useNetworkd = true;
        useDHCP = false;
      };
      systemd.network.networks."01-eth1" = {
        name = "eth1";
        networkConfig.Address = "192.168.1.${toString hostId}/24";
      };
      environment.etc = {
        "scion/topology.json".source = ./topology${toString hostId}.json;
        "scion/crypto/as".source = trust-root-configuration-keys + "/AS${toString hostId}";
        "scion/certs/ISD42-B1-S1.trc".source = trust-root-configuration-keys + "/ISD42-B1-S1.trc";
        "scion/keys/master0.key".text = "U${toString hostId}v4k23ZXjGDwDofg/Eevw==";
        "scion/keys/master1.key".text = "dBMko${toString hostId}qMS8DfrN/zP2OUdA==";
      };
      environment.systemPackages = [
        pkgs.scion
      ];
    })
  ];
in
{
  name = "scion-test";
  nodes = {
    scion01 = { ... }: {
      imports = (imports 1);
    };
    scion02 = { ... }: {
      imports = (imports 2);
    };
    scion03 = { ... }: {
      imports = (imports 3);
    };
    scion04 = { ... }: {
      imports = (imports 4);
      networking.interfaces."lo".ipv4.addresses = [{ address = "172.16.1.1"; prefixLength = 32; }];
      services.scion.scion-ip-gateway = {
        enable = true;
        config = {
          tunnel = {
            src_ipv4 = "172.16.1.1";
          };
        };
        trafficConfig = {
          ASes = {
            "42-ffaa:1:5" = {
              Nets = [
                "172.16.100.0/24"
              ];
            };
          };
          ConfigVersion = 9001;
        };
      };
    };
    scion05 = { ... }: {
      imports = (imports 5);
      networking.interfaces."lo".ipv4.addresses = [{ address = "172.16.100.1"; prefixLength = 32; }];
      services.scion.scion-ip-gateway = {
        enable = true;
        config = {
          tunnel = {
            src_ipv4 = "172.16.100.1";
          };
        };
        trafficConfig = {
          ASes = {
            "42-ffaa:1:4" = {
              Nets = [
                "172.16.1.0/24"
              ];
            };
          };
          ConfigVersion = 9001;
        };
      };
    };
  };
  testScript = let
    pingAll = pkgs.writeShellScript "ping-all-scion.sh" ''
      addresses="42-ffaa:1:1 42-ffaa:1:2 42-ffaa:1:3 42-ffaa:1:4 42-ffaa:1:5"
      timeout=100
      wait_for_all() {
        ret=0
        for as in "$@"
        do
          scion showpaths $as --no-probe > /dev/null
          ret=$?
          if [ "$ret" -ne "0" ]; then
            break
          fi
        done
        return $ret
      }
      ping_all() {
        ret=0
        for as in "$@"
        do
          scion ping "$as,127.0.0.1" -c 3
          ret=$?
          if [ "$ret" -ne "0" ]; then
            break
          fi
        done
        return $ret
      }
      for i in $(seq 0 $timeout); do
        sleep 1
        wait_for_all $addresses || continue
        ping_all $addresses && exit 0
      done
      exit 1
    '';
  in
  ''
    # List of AS instances
    machines = [scion01, scion02, scion03, scion04, scion05]

    # Functions to avoid many for loops
    def start(allow_reboot=False):
        for i in machines:
            i.start(allow_reboot=allow_reboot)

    def wait_for_unit(service_name):
        for i in machines:
            i.wait_for_unit(service_name)

    def succeed(command):
        for i in machines:
            i.succeed(command)

    def reboot():
        for i in machines:
            i.reboot()

    def crash():
        for i in machines:
            i.crash()

    # Start all machines, allowing reboot for later
    start(allow_reboot=True)

    # Wait for scion-control.service on all instances
    wait_for_unit("scion-control.service")

    # Ensure cert is valid against TRC
    succeed("scion-pki certificate verify --trc /etc/scion/certs/*.trc /etc/scion/crypto/as/*.pem >&2")

    # Execute pingAll command on all instances
    succeed("${pingAll} >&2")

    # Execute ICMP pings across scion-ip-gateway
    scion04.succeed("ping -c 3 172.16.100.1 >&2")
    scion05.succeed("ping -c 3 172.16.1.1 >&2")

    # Restart all scion services and ping again to test robustness
    succeed("systemctl restart scion-* >&2")
    succeed("${pingAll} >&2")

    # Reboot machines, wait for service, and ping again
    reboot()
    wait_for_unit("scion-control.service")
    succeed("${pingAll} >&2")

    # Crash, start, wait for service, and ping again
    crash()
    start()
    wait_for_unit("scion-control.service")
    succeed("pkill -9 scion-* >&2")
    wait_for_unit("scion-control.service")
    succeed("${pingAll} >&2")
  '';
})
