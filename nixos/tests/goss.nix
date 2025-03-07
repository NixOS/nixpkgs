import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "goss";
    meta.maintainers = [ lib.maintainers.anthonyroussel ];

    nodes.machine = {
      environment.systemPackages = [ pkgs.jq ];

      services.goss = {
        enable = true;

        environment = {
          GOSS_FMT = "json";
        };

        settings = {
          addr."tcp://localhost:8080" = {
            reachable = true;
            local-address = "127.0.0.1";
          };
          command."check-goss-version" = {
            exec = "${lib.getExe pkgs.goss} --version";
            exit-status = 0;
          };
          dns.localhost.resolvable = true;
          file."/nix" = {
            filetype = "directory";
            exists = true;
          };
          group.root.exists = true;
          kernel-param."kernel.ostype".value = "Linux";
          user.root.exists = true;
        };
      };
    };

    testScript = ''
      import json

      machine.wait_for_unit("goss.service")
      machine.wait_for_open_port(8080)

      with subtest("returns health status"):
        result = json.loads(machine.succeed("curl -sS http://localhost:8080/healthz"))

        assert len(result["results"]) == 8, f".results should be an array of 10 items, was {result['results']!r}"
        assert result["summary"]["failed-count"] == 0, f".summary.failed-count should be zero, was {result['summary']['failed-count']}"
        assert result["summary"]["test-count"] == 8, f".summary.test-count should be 10, was {result['summary']['test-count']}"
    '';
  }
)
