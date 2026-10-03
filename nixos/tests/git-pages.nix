{ lib, pkgs, ... }:
{
  name = "git-pages";

  meta.maintainers = with lib.maintainers; [ kiara ];

  nodes.machine = {
    environment.systemPackages = [ pkgs.curl ];

    services.git-pages = {
      enable = true;
      openFirewall = true;
      settings.server = {
        # A privileged port, so the test covers the capability the module
        # grants for one. nginx takes port 80 in front of it.
        pages = "tcp/:81";
        # A single dash disables a listener.
        caddy = "-";
      };
      # The secrets file takes the same keys as `settings` and wins over it, so
      # a moved metrics endpoint shows that git-pages read it.
      secretFile = "/etc/git-pages-secrets.toml";
      # git-pages serves the site of the host name of the request, and the test
      # asks for `localhost`.
      nginx.virtualHosts."localhost" = { };
    };

    # git-pages accepts an upload without a forge token only in this mode.
    systemd.services.git-pages.environment.PAGES_INSECURE = "1";

    environment.etc."git-pages-secrets.toml".text = ''
      [server]
      metrics = "tcp/localhost:3005"
    '';
  };

  testScript =
    let
      testSite = pkgs.runCommand "git-pages-testsite.tar" { } ''
        echo It works! > index.html
        tar cf $out index.html
      '';
    in
    ''
      machine.wait_for_unit("git-pages.service")
      machine.wait_for_open_port(81)
      machine.wait_for_unit("nginx.service")
      machine.wait_for_open_port(80)

      with subtest("a dash disables a listener"):
          machine.fail("curl -f --max-time 5 http://localhost:3001/")

      with subtest("the secrets file overrides the generated config"):
          machine.wait_for_open_port(3005)
          machine.succeed("curl -f http://localhost:3005/metrics")
          machine.fail("curl -f --max-time 5 http://localhost:3002/metrics")

      with subtest("a site is unhealthy until it is uploaded"):
          machine.fail("curl -f http://localhost/.git-pages/health")

      with subtest("an uploaded site is served through nginx"):
          machine.succeed(
              "curl -f http://localhost/ -X PUT"
              " --data-binary @${testSite}"
              " --header 'Content-Type: application/x-tar'"
          )
          machine.wait_until_succeeds("test -f /var/lib/git-pages/site/localhost/.index")
          machine.succeed("curl -f http://localhost/.git-pages/health")
          machine.succeed("curl -f http://localhost/ | grep -F 'It works!'")

      with subtest("nginx passes the Server header of git-pages through"):
          # `git-pages-cli` does not accept an upload without it.
          machine.succeed("curl -fsI http://localhost/ | grep -i '^server: *git-pages'")

      with subtest("the site survives a restart"):
          machine.systemctl("restart git-pages.service")
          machine.wait_for_open_port(81)
          machine.succeed("curl -f http://localhost/ | grep -F 'It works!'")
    '';
}
