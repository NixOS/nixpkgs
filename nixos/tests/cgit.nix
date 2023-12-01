import ./make-test-python.nix ({ pkgs, ... }:
let
  robotsTxt = pkgs.writeText "cgit-robots.txt" ''
    User-agent: *
    Disallow: /
  '';
in {
  name = "cgit";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ schnusch ];
  };

  nodes = {
    server = { ... }: {
      services.cgit."localhost" = {
        enable = true;
        package = pkgs.cgit.overrideAttrs ({ postInstall, ... }: {
          postInstall = ''
            ${postInstall}
            cp ${robotsTxt} "$out/cgit/robots.txt"
          '';
        });
        nginx.location = "/(c)git/";
        repos = {
          some-repo = {
            path = "/srv/git/some-repo";
            desc = "some-repo description";
          };
        };
      };

      environment.systemPackages = [ pkgs.git ];
    };
  };

  testScript = { nodes, ... }: ''
    start_all()

    server.wait_for_unit("nginx.service")
    server.wait_for_unit("network.target")
    server.wait_for_open_port(80)

    server.succeed("curl -fsS http://localhost/%28c%29git/cgit.css")

    server.succeed("curl -fsS http://localhost/%28c%29git/robots.txt | diff -u - ${robotsTxt}")

    server.succeed(
        "curl -fsS http://localhost/%28c%29git/ | grep -F 'some-repo description'"
    )

    server.fail("curl -fsS http://localhost/robots.txt")

    server.succeed("${pkgs.writeShellScript "setup-cgit-test-repo" ''
      set -e
      git init --bare -b master /srv/git/some-repo
      git init -b master reference
      cd reference
      git remote add origin /srv/git/some-repo
      date > date.txt
      git add date.txt
      git -c user.name=test -c user.email=test@localhost commit -m 'add date'
      git push -u origin master
    ''}")

    server.succeed(
        "curl -fsS 'http://localhost/%28c%29git/some-repo/plain/date.txt?id=master' | diff -u reference/date.txt -"
    )

    server.succeed(
       "git clone http://localhost/%28c%29git/some-repo && diff -u reference/date.txt some-repo/date.txt"
    )
  '';
})
