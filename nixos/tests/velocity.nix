{ lib, pkgs, ... }:
{
  name = "velocity";
  meta.maintainers = [ lib.maintainers.Tert0 ];

  nodes.server =
    { ... }:
    {
      imports =
        let
          mkVelocityService = name: pkg: {
            systemd.sockets.${name} = {
              socketConfig = {
                ListenFIFO = "/run/${name}.stdin";
                Service = "${name}";
              };
            };
            systemd.services.${name} = {
              serviceConfig = {
                ExecStart = "${pkg}/bin/velocity";
                DynamicUser = true;
                StateDirectory = "${name}";
                WorkingDirectory = "/var/lib/${name}";

                Sockets = "${name}.socket";
                StandardInput = "socket";
                StandardOutput = "journal";
                StandardError = "journal";
              };
            };
          };
        in
        [
          (mkVelocityService "velocity-without-native" (
            pkgs.velocity.override { withVelocityNative = false; }
          ))
          (mkVelocityService "velocity-with-native" (pkgs.velocity.override { withVelocityNative = true; }))
        ];

      environment.systemPackages = [ (pkgs.python3.withPackages (p: [ p.mcstatus ])) ];
    };

  testScript = ''
    def test_velocity(name: str, native: bool):
      server.start_job(name)
      server.wait_for_unit(name);
      server.wait_for_open_port(25565)
      server.wait_until_succeeds(f"journalctl -b -u {name} | grep -q 'Booting up Velocity nixpkgs-${pkgs.velocity.version}...'")
      connections_startup_query = "Connections will use epoll channels, libdeflate (.+) compression, OpenSSL 3.x.x (.+) ciphers" if native else "Connections will use epoll channels, Java compression, Java ciphers"
      server.wait_until_succeeds(f"journalctl -b -u {name} | grep -q -E '{connections_startup_query}'")
      server.wait_until_succeeds(f"journalctl -b -u {name} | grep -q 'Done ([0-9]*.[0-9]*s)!'");

      _, status_result = server.execute("python -m mcstatus localhost:25565 status")
      assert "A Velocity Server" in status_result

      server.execute(f"echo stop > /run/{name}.stdin")
      server.wait_for_closed_port(25565);

    test_velocity("velocity-without-native", False)
    test_velocity("velocity-with-native", True)
  '';
}
