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

        systemd.services = {
          windmill-worker = {
            # "dotnet restore" (csharp executor) attempts to download the package index from api.nuget.org by default.
            # Using the following per-job nuget.config file will erase all package source references to prevent downloading.
            environment.FORCE_NUGET_CONFIG = ''
              <?xml version="1.0" encoding="utf-8"?>
              <configuration>
                <packageSources>
                    <clear />
                </packageSources>
              </configuration>
            '';
          };
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
    import time
    # windmill.forward_port(8001, 8001) # DEBUG interactive

    with subtest("Server smoketest"):
      windmill.wait_for_unit("windmill.target")
      # ERROR; Do not early timeout because windmill starts running migration scripts.
      # There is no communication to systemd that signals migrations have finished.
      windmill.wait_for_open_port(8001)
      # NOTE; Wait a couple of seconds for all windmill components to finalise their database migration flow. This prevents race conditions on schema constraints.
      time.sleep(10)  # seconds
      windmill.succeed("curl --silent --fail http://windmill:8001")
      t.assertIn("v${pkgs.windmill.version}", machine.succeed("curl --silent --fail http://windmill:8001/api/version"), "Mismatched version response")

    with subtest("Validation"):
      windmill.succeed("integration-test --language python3 --script ${./python3.script} --input ${./python3.input}")
      windmill.succeed("integration-test --language go --script ${./go.script} --input ${./go.input}")
      windmill.succeed("integration-test --language bun --script ${./bun.script} --input ${./bun.input}")
      windmill.succeed("integration-test --language deno --script ${./deno.script} --input ${./deno.input}")
      windmill.succeed("integration-test --language php --script ${./php.script} --input ${./php.input}")
      windmill.succeed("integration-test --language bash --script ${./bash.script} --input ${./bash.input}")
      windmill.succeed("integration-test --language powershell --script ${./powershell.script} --input ${./powershell.input}")

      # ERROR; "dotnet restore" requires write-access to <some-path(:home?)>/.dotnet
      # -- System.IO.IOException: Read-only file system : '/.dotnet'
      #
      # ERROR; "dotnet publish" requires internet connectivity to fetch "compilation workload" dependencies
      # -- error NU1100: Unable to resolve 'Microsoft.NET.ILLink.Tasks (>= 9.0.10)' for 'net9.0'.
      #
      # DISABLED windmill.succeed("integration-test --language csharp --script ${./csharp.script} --input ${./csharp.input}")
  '';
}
