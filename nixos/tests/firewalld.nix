import ./make-test-python.nix {
  name = "firewalld";

  nodes = {
    walled = {
      services.firewalld.enable = true;
      services.httpd.enable = true;
      services.httpd.adminAddr = "foo@example.org";
    };

    open = {
      services.firewalld = {
        enable = true;
        config.DefaultZone = "trusted";
      };
      services.httpd.enable = true;
      services.httpd.adminAddr = "foo@example.org";
    };
  };

  testScript = ''
    start_all()

    walled.wait_for_unit("firewalld");
    walled.wait_for_unit("httpd")

    open.wait_for_unit("network.target")

    with subtest("enable denial logging"):
      walled.succeed("firewall-cmd --set-log-denied=all")
      walled.succeed("firewall-cmd --runtime-to-permanent")

    with subtest("walled local httpd works"):
      walled.succeed("curl -v http://localhost/ >&2")

    with subtest("incoming connections are blocked"):
      open.fail("curl --fail --connect-timeout 2 http://walled/ >&2")

    with subtest("outgoing connections are allowed"):
      walled.succeed("curl -v http://open/ >&2")

    with subtest("runtime configuration can be changed"):
      walled.succeed("firewall-cmd --add-service=http")
      open.succeed("curl -v http://walled/ >&2")

    with subtest("runtime configuration are not permanent"):
      walled.succeed("firewall-cmd --complete-reload")
      open.fail("curl --fail --connect-timeout 2 http://walled/ >&2")

    with subtest("permanent configuration are permanent"):
      walled.succeed("firewall-cmd --add-service=http --permanent")
      walled.succeed("firewall-cmd --complete-reload")
      open.succeed("curl -v http://walled/ >&2")
  '';
}
