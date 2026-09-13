{ lib, runTest }:

{
  without-webui = runTest {
    name = "suwayomi-server-without-webui";

    nodes.machine.services.suwayomi-server = {
      enable = true;
      settings.server = {
        debugLogsEnabled = true;
        port = 1234;
        webUIEnabled = false;
        kcefEnabled = false;
      };
    };

    testScript = ''
      machine.wait_for_unit("suwayomi-server.service")
      machine.wait_for_open_port(1234)
    '';

    meta.maintainers = with lib.maintainers; [
      nanoyaki
      ratcornu
    ];
  };

  without-auth = runTest {
    name = "suwayomi-server-without-auth";

    nodes.machine.services.suwayomi-server = {
      enable = true;
      settings.server = {
        debugLogsEnabled = true;
        port = 1234;
        kcefEnabled = false;
        webUIFlavor = "Custom";
      };
    };

    testScript = ''
      machine.wait_for_unit("suwayomi-server.service")
      machine.wait_for_open_port(1234)
      machine.succeed("curl --fail http://127.0.0.1:1234/")
    '';

    meta.maintainers = with lib.maintainers; [
      nanoyaki
      ratcornu
    ];
  };

  with-auth = runTest {
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
          debugLogsEnabled = true;
          kcefEnabled = false;
          port = 1234;
          webUIFlavor = "Custom";
          authMode = "basic_auth";
          authUsername = "alice";
          authPasswordFile = "/etc/snakeoil";
        };
      };
    };

    testScript = ''
      machine.wait_for_unit("suwayomi-server.service")
      machine.wait_for_open_port(1234)
      machine.succeed("curl --fail -u alice:pass http://127.0.0.1:1234/")
    '';

    meta.maintainers = with lib.maintainers; [
      nanoyaki
      ratcornu
    ];
  };
}
