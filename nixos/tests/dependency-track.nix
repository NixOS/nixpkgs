{ pkgs, ... }:
let
  dependencyTrackPort = 8081;
in
{
  name = "dependency-track";
  meta = {
    maintainers = pkgs.lib.teams.cyberus.members;
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
        systemd.services.dependency-track = {
          # source: https://github.com/DependencyTrack/dependency-track/blob/37e0ba59e8057c18a87a7a76e247a8f75677a56c/dev/scripts/data-nist-generate-dummy.sh
          preStart = ''
            set -euo pipefail

            NIST_DIR="$HOME/.dependency-track/nist"

            rm -rf "$NIST_DIR"
            mkdir -p "$NIST_DIR"

            for feed in $(seq "2024" "2002"); do
              touch "$NIST_DIR/nvdcve-1.1-$feed.json.gz"
              echo "9999999999999" > "$NIST_DIR/nvdcve-1.1-$feed.json.gz.ts"
            done
          '';
        };
        services.dependency-track = {
          enable = true;

          # The Java VM defaults (correctly) to tiny heap on this tiny
          # VM, but that's not enough to start dependency-track.
          javaArgs = [ "-Xmx4G" ];

          port = dependencyTrackPort;
          nginx.domain = "localhost";
          database.passwordFile = "${pkgs.writeText "dbPassword" ''hunter2'THE'''H''''E''}";
        };
      };
  };

  testScript =
    # python
    ''
      import json

      start_all()

      server.wait_for_unit("dependency-track.service")
      server.wait_until_succeeds(
        "journalctl -o cat -u dependency-track.service | grep 'Dependency-Track is ready'"
      )
      server.wait_for_open_port(${toString dependencyTrackPort})

      with subtest("version api returns correct version"):
        version = json.loads(
          server.succeed("curl http://localhost/api/version")
        )
        assert version["version"] == "${pkgs.dependency-track.version}"

      with subtest("nginx serves frontend"):
        server.succeed("curl http://localhost/ | grep \"<title>Dependency-Track</title>\"")
    '';
}
