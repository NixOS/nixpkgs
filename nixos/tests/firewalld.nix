{ lib, pkgs, ... }:
{
  name = "firewalld";
  meta.maintainers = with pkgs.lib.maintainers; [
    prince213
  ];

  nodes = {
    walled = {
      networking.nftables.enable = true;
      services.firewalld.enable = true;
      services.httpd.enable = true;
      services.httpd.adminAddr = "foo@example.org";
    };

    open = {
      networking.nftables.enable = true;
      services.firewalld = {
        enable = true;
        settings.DefaultZone = "trusted";
      };
      services.httpd.enable = true;
      services.httpd.adminAddr = "foo@example.org";
    };
  };

  testScript = ''
    start_all()

    walled.wait_for_unit("firewalld")
    walled.wait_for_unit("httpd")

    open.wait_for_unit("network.target")

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
  '';
}
