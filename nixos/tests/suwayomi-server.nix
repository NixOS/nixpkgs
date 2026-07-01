{ lib, runTest }:

let
  inherit (lib) recursiveUpdate;

  baseTestConfig = {
    meta.maintainers = with lib.maintainers; [
      ratcornu
      nanoyaki
    ];

    nodes.machine.services.suwayomi-server = {
      enable = true;
      settings.server.port = 1234;
    };
  };
in

{
  without-auth = runTest (
    recursiveUpdate baseTestConfig {
      name = "suwayomi-server-without-auth";

      testScript = ''
        machine.wait_for_unit("suwayomi-server.service")
        machine.wait_for_open_port(1234)
        # We have to wait since suwayomi-webui tries
        # to download it's webui even if it's bundled.
        # That process runs parallel to the actual
        # startup and therefore the bundled webui
        # won't get extracted and served until it
        # failed to download 3 times.
        machine.wait_until_succeeds("curl --fail http://127.0.0.1:1234/", 15)
      '';
    }
  );

  with-auth = runTest (
    recursiveUpdate baseTestConfig {
      name = "suwayomi-server-with-auth";

      nodes.machine = {
        systemd.tmpfiles.settings.test-password."/etc/snakeoil".f = {
          mode = "400";
          user = "suwayomi";
          group = "suwayomi";
          argument = "pass";
        };

        services.suwayomi-server = {
          enable = true;

          settings.server = {
            authMode = "basic_auth";
            authUsername = "alice";
            authPasswordFile = "/etc/snakeoil";
          };
        };
      };

      testScript = ''
        machine.wait_for_unit("suwayomi-server.service")
        machine.wait_for_open_port(1234)
        # See the comment above
        machine.wait_until_succeeds("curl --fail -u alice:pass http://127.0.0.1:1234/", 15)
      '';
    }
  );
}
