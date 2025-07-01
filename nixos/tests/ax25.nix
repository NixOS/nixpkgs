{ pkgs, lib, ... }:

let
  baud = 57600;
  tty = "/dev/ttyACM0";
  port = "tnc0";
  socatPort = 1234;

  createAX25Node = nodeId: {
    boot.kernelModules = [ "ax25" ];

    networking.firewall.allowedTCPPorts = [ socatPort ];

    environment.systemPackages = with pkgs; [
      libax25
      ax25-tools
      ax25-apps
      socat
    ];

    services.ax25.axports."${port}" = {
      inherit baud tty;
      enable = true;
      callsign = "NOCALL-${toString nodeId}";
      description = "mocked tnc";
    };

    services.ax25.axlisten = {
      enable = true;
    };

    # All mocks radios will connect back to socat-broker on node 1 in order to get
    # all messages that are "broadcasted over the ether"
    systemd.services.ax25-mock-hardware = {
      description = "mock AX.25 TNC and Radio";
      wantedBy = [ "default.target" ];
      before = [
        "ax25-kissattach-${port}.service"
        "axlisten.service"
      ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${pkgs.socat}/bin/socat -d -d tcp:192.168.1.1:${toString socatPort} pty,link=${tty},b${toString baud},raw";
      };
    };
  };
in
{
  name = "ax25Simple";
  nodes = {
    node1 = lib.mkMerge [
      (createAX25Node 1)
      # mimicking radios on the same frequency
      {
        systemd.services.ax25-mock-ether = {
          description = "mock radio ether";
          wantedBy = [ "default.target" ];
          requires = [ "network.target" ];
          before = [ "ax25-mock-hardware.service" ];
          # broken needs access to "ss" or "netstat"
          path = [ pkgs.iproute2 ];
          serviceConfig = {
            Type = "exec";
            ExecStart = "${pkgs.socat}/bin/socat-broker.sh tcp4-listen:${toString socatPort}";
          };
          postStart = "${pkgs.coreutils}/bin/sleep 2";
        };
      }
    ];
    node2 = createAX25Node 2;
    node3 = createAX25Node 3;
  };
  testScript =
    { ... }:
    ''
      def wait_for_machine(m):
        m.succeed("lsmod | grep ax25")
        m.wait_for_unit("ax25-axports.target")
        m.wait_for_unit("axlisten.service")
        m.fail("journalctl -o cat -u axlisten.service | grep -i \"no AX.25 port data configured\"")

      # start the first node since the socat-broker needs to be running
      node1.start()
      node1.wait_for_unit("ax25-mock-ether.service")
      wait_for_machine(node1)

      node2.start()
      node3.start()
      wait_for_machine(node2)
      wait_for_machine(node3)

      # Node 1 -> Node 2
      node1.succeed("echo hello | ax25_call ${port} NOCALL-1 NOCALL-2")
      node2.sleep(1)
      node2.succeed("journalctl -o cat -u axlisten.service | grep -A1 \"NOCALL-1 to NOCALL-2 ctl I00\" | grep hello")

      # Node 1 -> Node 3
      node1.succeed("echo hello | ax25_call ${port} NOCALL-1 NOCALL-3")
      node3.sleep(1)
      node3.succeed("journalctl -o cat -u axlisten.service | grep -A1 \"NOCALL-1 to NOCALL-3 ctl I00\" | grep hello")

      # Node 2 -> Node 1
      # must sleep due to previous ax25_call lingering
      node2.sleep(5)
      node2.succeed("echo hello | ax25_call ${port} NOCALL-2 NOCALL-1")
      node1.sleep(1)
      node1.succeed("journalctl -o cat -u axlisten.service | grep -A1 \"NOCALL-2 to NOCALL-1 ctl I00\" | grep hello")

      # Node 2 -> Node 3
      node2.succeed("echo hello | ax25_call ${port} NOCALL-2 NOCALL-3")
      node3.sleep(1)
      node3.succeed("journalctl -o cat -u axlisten.service | grep -A1 \"NOCALL-2 to NOCALL-3 ctl I00\" | grep hello")

      # Node 3 -> Node 1
      # must sleep due to previous ax25_call lingering
      node3.sleep(5)
      node3.succeed("echo hello | ax25_call ${port} NOCALL-3 NOCALL-1")
      node1.sleep(1)
      node1.succeed("journalctl -o cat -u axlisten.service | grep -A1 \"NOCALL-3 to NOCALL-1 ctl I00\" | grep hello")

      # Node 3 -> Node 2
      node3.succeed("echo hello | ax25_call ${port} NOCALL-3 NOCALL-2")
      node2.sleep(1)
      node2.succeed("journalctl -o cat -u axlisten.service | grep -A1 \"NOCALL-3 to NOCALL-2 ctl I00\" | grep hello")
    '';
}
