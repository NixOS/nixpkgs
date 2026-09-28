{ lib, pkgs, ... }:
{
  name = "xinetd";
  meta.maintainers = [ lib.maintainers.h7x4 ];

  containers.machine = {
    environment.systemPackages = [ pkgs.netcat ];

    services.xinetd = {
      enable = true;
      services = [
        {
          name = "ping-pong-tcp";
          protocol = "tcp";
          port = 8765;
          unlisted = true;
          server =
            let
              pingPongTcp = pkgs.writeShellScript "ping-pong-tcp" ''
                read -r line
                if [ "$line" = "ping" ]; then
                  echo "pong"
                fi
              '';
            in
            "${pingPongTcp}";
        }
        {
          name = "ping-pong-udp";
          protocol = "udp";
          port = 8766;
          unlisted = true;
          server =
            let
              pingPongUdp = pkgs.writers.writePython3 "ping-pong-udp" { } ''
                import socket

                sock = socket.socket(fileno=0)
                data, peer = sock.recvfrom(1024)
                sock.connect(peer)
                if data.strip() == b"ping":
                    sock.send(b"pong\n")
              '';
            in
            "${pingPongUdp}";
        }
      ];
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("xinetd.service")
    machine.wait_for_open_port(8765)

    with subtest("Query TCP"):
        output = machine.succeed("nc -w5 localhost 8765 <<<ping")
        assert "pong" in output, f"Unexpected output: {output}"

    with subtest("Query UDP"):
        output = machine.succeed("nc -u -w5 localhost 8766 <<<ping")
        assert "pong" in output, f"Unexpected output: {output}"
  '';
}
