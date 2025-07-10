{ lib, runTest }:

let
  baseTestConfig = {
    meta.maintainers = with lib.maintainers; [ ratcornu ];

    testScript = ''
      machine.wait_for_unit("suwayomi-server.service")
      machine.wait_for_open_port(1234)
      machine.succeed("curl --fail http://localhost:1234/")
    '';
  };
in

{
  without-auth = runTest (
    baseTestConfig
    // {
      name = "suwayomi-server-without-auth";

      nodes.machine = {
        services.suwayomi-server = {
          enable = true;
          settings.server.port = 1234;
        };
      };
    }
  );

  with-auth = runTest (
    baseTestConfig
    // {
      name = "suwayomi-server-with-auth";

      nodes.machine =
        { pkgs, ... }:
        {
          services.suwayomi-server = {
            enable = true;

            settings.server = {
              port = 1234;
              basicAuthEnabled = true;
              basicAuthUsername = "alice";
              basicAuthPasswordFile = pkgs.writeText "snakeoil-pass.txt" "pass";
            };
          };
        };
    }
  );
}
