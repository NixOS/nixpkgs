import ./make-test-python.nix ({ pkgs, lib, ...} : {
  name = "davical";
  meta.maintainers = [ lib.maintainers.henson ];

  machine = { config, pkgs, ... }: {
    services.davical = {
      enable = true;
      webAdminPass = "password";
      virtualHost = {
        adminAddr = "root@localhost";
        forceSSL = false;
      };
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("postgresql.service")
    machine.wait_for_unit("phpfpm-davical.service")
    machine.wait_for_unit("httpd.service")

    page = machine.succeed("curl -L http://localhost/")
    assert "Log On Please" in page
  '';
})
