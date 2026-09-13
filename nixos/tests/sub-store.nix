{
  lib,
  pkgs,
  ...
}:
let
  testPort = 54321;
  secretPath = "/random-path";

  proxyData = {
    type = "socks5";
    host = "127.0.0.1";
    port = "7890";
  };
  dataFile = pkgs.writers.writeJSON "sub-store.json" {
    schemaVersion = "2.0";
    subs = [
      {
        content = "${proxyData.type}://${proxyData.host}:${proxyData.port}";
        name = "test";
        source = "local";
      }
    ];
  };
in
{
  name = "sub-store";

  nodes.machine =
    { pkgs, ... }:
    {
      systemd.tmpfiles.rules = [
        "C /var/lib/sub-store/sub-store.json 0666 root root - ${dataFile}"
      ];

      services.sub-store = {
        enable = true;
        openFirewall = true;
        port = testPort;
        mergeMode = true;
        environmentFile = pkgs.writeText "sub-store-env" (
          lib.generators.toKeyValue { } {
            SUB_STORE_FRONTEND_BACKEND_PATH = secretPath;
          }
        );
      };
    };

  extraPythonPackages =
    p: with p; [
      pyyaml
      types-pyyaml
    ];

  testScript = # py
    ''
      import yaml

      start_all()

      machine.wait_for_file("/var/lib/sub-store/sub-store.json")
      machine.wait_for_unit("sub-store.service")
      machine.wait_for_open_port(${toString testPort})

      with subtest("Verify API response"):
          response = machine.succeed("curl -sSf 'http://127.0.0.1:${toString testPort}${secretPath}/download/test?target=ShadowRocket'")

          data = yaml.safe_load(response)

          assert data["proxies"][0]["type"] == "${proxyData.type}"
          assert data["proxies"][0]["server"] == "${proxyData.host}"
          assert data["proxies"][0]["port"] == ${proxyData.port}
    '';

  meta.maintainers = with lib.maintainers; [ moraxyc ];
}
