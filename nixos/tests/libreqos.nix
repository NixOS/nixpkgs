{ lib, ... }:

{
  name = "libreqos";

  meta = {
    maintainers = [ lib.maintainers.stepbrobd ];
    teams = [ lib.teams.ngi ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.cores = 2;
      virtualisation.memorySize = 4096;

      environment.systemPackages = [ pkgs.curl ];

      # needed for lqos node_id
      networking.hostId = "deadbeef";

      # LibreQoS will not track interfaces with <= 2 tx queues
      systemd.services.lqos-test-iface = {
        wantedBy = [ "multi-user.target" ];
        before = [ "lqosd.service" ];
        requiredBy = [ "lqosd.service" ];
        path = [ pkgs.iproute2 ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          ip link add lqtest0 numtxqueues 2 numrxqueues 2 type veth peer name lqtest1 numtxqueues 2 numrxqueues 2
          ip link set lqtest0 up
          ip link set lqtest1 up
        '';
      };

      services.libreqos = {
        enable = true;
        settings = {
          bridge = {
            use_xdp_bridge = false;
            to_internet = "lqtest0";
            to_network = "lqtest1";
          };
          queues = {
            uplink_bandwidth_mbps = 100;
            downlink_bandwidth_mbps = 100;
            generated_pn_download_mbps = 100;
            generated_pn_upload_mbps = 100;
          };
          tuning.stop_irq_balance = false;
        };
      };

      systemd.tmpfiles.rules =
        let
          network = pkgs.writeText "network.json" (
            builtins.toJSON {
              Site_1 = {
                downloadBandwidthMbps = 500;
                uploadBandwidthMbps = 500;
                type = "Site";
                children.AP_A = {
                  downloadBandwidthMbps = 200;
                  uploadBandwidthMbps = 200;
                  type = "AP";
                };
              };
            }
          );
          dev = pkgs.writeText "ShapedDevices.csv" ''
            Circuit ID,Circuit Name,Device ID,Device Name,Parent Node,MAC,IPv4,IPv6,Download Min Mbps,Upload Min Mbps,Download Max Mbps,Upload Max Mbps,Comment
            1,Test Circuit,1,Test Device,AP_A,,100.64.0.2,,10,10,100,100,
          '';
        in
        [
          "d /var/lib/libreqos 0755 root root -"
          "L+ /var/lib/libreqos/network.json - - - - ${network}"
          "L+ /var/lib/libreqos/ShapedDevices.csv - - - - ${dev}"
        ];
    };

  testScript = ''
    machine.wait_for_unit("lqosd.service")
    machine.wait_for_unit("lqos_scheduler.service")

    # lqosd xpd programs to shaped ifaces
    machine.wait_until_succeeds("ip link show lqtest0 | grep -q xdp")
    machine.wait_until_succeeds("ip link show lqtest1 | grep -q xdp")

    # scheduler first run should build and apply the queue tree
    machine.wait_until_succeeds("test -s /var/lib/libreqos/state/shaping/queuingStructure.json")
    machine.wait_until_succeeds("tc qdisc show dev lqtest0 | grep -q cake")
    machine.wait_until_succeeds("tc qdisc show dev lqtest1 | grep -q cake")

    # web UI
    machine.wait_for_open_port(9123)
    machine.succeed("curl -sSf http://127.0.0.1:9123/ -o /dev/null")

    # check user management
    machine.succeed("lqusers add --username admin --role admin --password s3cr3t")
    machine.succeed("lqusers list | grep -q admin")
  '';
}
