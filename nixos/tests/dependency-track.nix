{ lib, config, ... }:
{
  name = "dependency-track";
  meta = {
    maintainers = with lib.maintainers; [
      e1mo
      xanderio
    ];
  };

  nodes = {
    server =
      { pkgs, ... }:
      {
        virtualisation = {
          cores = 2;
          diskSize = 4096;
          memorySize = 1024 * 2;
        };

        environment.systemPackages = with pkgs; [ curl ];
        services.dependency-track = {
          enable = true;

          # The Java VM defaults (correctly) to tiny heap on this tiny
          # VM, but that's not enough to start dependency-track.
          javaArgs = [ "-Xmx4G" ];

          nginx.domain = "localhost";
          database.passwordFile = "${pkgs.writeText "dbPassword" "hunter2'THE''H'''E"}";
        };
      };
  };

  testScript =
    # python
    ''
      import json

      start_all()

      server.wait_for_unit("dependency-track.service")
      # server.wait_until_succeeds(
      #   "journalctl -o cat -u dependency-track.service | grep 'Dependency-Track is ready'"
      # )
      server.wait_for_open_port(${toString config.nodes.server.services.dependency-track.port})

      with subtest("version api returns correct version"):
        version = json.loads(
          server.succeed("curl http://localhost/api/version")
        )
        assert version["version"] == "${config.nodes.server.nixpkgs.pkgs.dependency-track.version}"

      with subtest("nginx serves frontend"):
        server.succeed("curl http://localhost/ | grep \"<title>Dependency-Track</title>\"")
    '';
}
