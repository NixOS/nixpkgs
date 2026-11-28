{ lib, ... }:
{
  name = "tcpcrypt";
  meta.maintainers = [ lib.maintainers.h7x4 ];

  nodes = {
    server =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        networking.tcpcrypt.enable = true;
        networking.firewall.allowedTCPPorts = map lib.toInt config.systemd.sockets.echo.listenStreams;

        environment.systemPackages = [ pkgs.tcpcrypt ];

        systemd.sockets.echo = {
          wantedBy = [ "sockets.target" ];
          listenStreams = [
            "4242"
            "4243"
          ];
          socketConfig.Accept = true;
        };

        systemd.services."echo@".serviceConfig = {
          ExecStart = lib.getExe' pkgs.coreutils "cat";
          StandardInput = "socket";
        };

        specialisation.without-tcpcrypt.configuration = {
          networking.tcpcrypt.enable = lib.mkForce false;
        };
      };

    client =
      { pkgs, ... }:
      {
        networking.tcpcrypt.enable = true;

        environment.systemPackages = [
          pkgs.tcpcrypt
          pkgs.socat
        ];
      };
  };

  testScript =
    { nodes, ... }:
    let
      port1 = lib.elemAt nodes.server.systemd.sockets.echo.listenStreams 0;
      port2 = lib.elemAt nodes.server.systemd.sockets.echo.listenStreams 1;
    in
    ''
      def test_connection(message: str, port: int) -> None:
          client.succeed("truncate -s 0 /tmp/reply")
          client.succeed(
              "systemd-run "
              "--collect "
              "--setenv=PATH=/run/current-system/sw/bin "
              "--property=Type=oneshot "
              "--no-block "
              f"socat TCP:server:{port} SYSTEM:'echo {message}; cat > /tmp/reply'"
          )
          client.wait_until_succeeds(f"grep -q {message} /tmp/reply")

      def session_id(machine: BaseMachine, port: int) -> str | None:
          for line in machine.succeed("tcnetstat").splitlines()[1:]:
              local, foreign, sid = line.split()
              if local.endswith(f":{port}") or foreign.endswith(f":{port}"):
                  return sid
          return None

      start_all()

      server.wait_for_unit("tcpcrypt.service")
      server.wait_for_unit("echo.socket")
      client.wait_for_unit("tcpcrypt.service")

      with subtest("Traffic is diverted to tcpcryptd"):
          for machine in [server, client]:
              machine.succeed("iptables -t raw -C PREROUTING -j nixos-tcpcrypt")
              machine.succeed("iptables -t mangle -C POSTROUTING -j nixos-tcpcrypt")

      with subtest("Connection is encrypted"):
          test_connection("encrypted", ${port1})
          sid = session_id(client, ${port1})
          assert sid is not None, "client negotiated no tcpcrypt session"
          assert len(bytes.fromhex(sid)) > 0

          assert sid == session_id(server, ${port1}), "session ids differ between the two ends"

      with subtest("Firewall rules are removed"):
          server.succeed(
              "/run/current-system/specialisation/without-tcpcrypt/bin/switch-to-configuration test"
          )
          server.wait_until_fails("systemctl is-active tcpcrypt.service")
          server.fail("iptables -t raw -C PREROUTING -j nixos-tcpcrypt")
          server.fail("iptables -t mangle -C POSTROUTING -j nixos-tcpcrypt")
          server.fail("iptables -t raw -L nixos-tcpcrypt")
          server.fail("iptables -t mangle -L nixos-tcpcrypt")

      with subtest("Fallback to plaintext"):
          server.wait_for_unit("echo.socket")
          test_connection("plaintext", ${port2})
          assert session_id(client, ${port2}) is None, "client negotiated tcpcrypt with a plain host"
    '';
}
