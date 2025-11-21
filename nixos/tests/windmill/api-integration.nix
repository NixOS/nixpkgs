{ lib, pkgs, ... }:
{
  name = "windmill-api";

  nodes = {
    windmill =
      { pkgs, lib, ... }:
      {
        virtualisation.memorySize = 2048; # 2GB
        networking.firewall.allowedTCPPorts = [ 8001 ];
        services.windmill = {
          enable = true;

          serverPort = 8001;
          database.createLocally = true;
        };

        environment.systemPackages = [
          (pkgs.writers.writePython3Bin "integration-test" {
            flakeIgnore = [
              "E265" # block comment should start with '# '
              "E501" # line too long (NN > 79 characters)
            ];
          } (builtins.readFile ./api-integration.py))
        ];
      };
  };

  testScript = ''
    # windmill.forward_port(8001, 8001) # DEBUG interactive

    with subtest("Server smoketest"):
      windmill.wait_for_unit("windmill.target")
      # ERROR; Do not early timeout because windmill starts running migration scripts.
      # There is no communication to systemd that signals migrations have finished.
      windmill.wait_for_open_port(8001)
      windmill.succeed("curl --silent --fail http://windmill:8001")
      t.assertIn("v${pkgs.windmill.version}", machine.succeed("curl --silent --fail http://windmill:8001/api/version"), "Mismatched version response")

    with subtest("Validation"):
      windmill.succeed("integration-test --language python3 --script ${./python3.script} --input ${./python3.input}")
  '';
}
