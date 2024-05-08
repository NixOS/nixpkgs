import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "firefly-iii";
  meta.maintainers = [ lib.maintainers.savyajha ];

  nodes.machine = { config, ... }: {
    environment.etc = {
      "firefly-iii-appkey".text = "TestTestTestTestTestTestTestTest";
    };
    services.firefly-iii = {
      enable = true;
      virtualHost = "http://localhost";
      enableNginx = true;
      settings = {
        APP_KEY_FILE = "/etc/firefly-iii-appkey";
        LOG_CHANNEL = "stdout";
        SITE_OWNER = "mail@example.com";
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("phpfpm-firefly-iii.service")
    machine.wait_for_unit("nginx.service")
    machine.succeed("curl -fvvv -Ls http://localhost/ | grep 'Firefly III'")
  '';
})
