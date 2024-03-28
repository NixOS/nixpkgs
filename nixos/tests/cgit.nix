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
      services.cgit = {
        enable = true;
        package = pkgs.cgit.overrideAttrs ({ postInstall, ... }: {
          postInstall = ''
            ${postInstall}
            cp ${robotsTxt} "$out/cgit/robots.txt"
          '';
        });
        virtualHosts."localhost".locations."/(c)git/" = {
          repos = {
            some-repo = {
              path = "/srv/git/some-repo";
              desc = "some-repo description";
            };
          };
          locationConfig = {
            basicAuth = {
              git = "password";
            };
          };
        };
      };

      environment.systemPackages = [ pkgs.coreutils pkgs.git ];
    };
  };

  testScript = { nodes, ... }: ''
    start_all()

    server.wait_for_unit("nginx.service")
    server.wait_for_unit("network.target")
    server.wait_for_open_port(80)

    server.succeed("curl -fsSu git:password http://localhost/cgit.css")

    server.succeed("curl -fsSu git:password http://localhost/robots.txt | diff -u - ${robotsTxt}")

    server.succeed(
        "curl -fsSu git:password http://localhost/%28c%29git/ | grep -F 'some-repo description'"
    )

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
        "curl -fsSu git:password 'http://localhost/%28c%29git/some-repo/plain/date.txt?id=master' | diff -u reference/date.txt -"
    )

    server.fail("GIT_ASKPASS=true git clone http://localhost/%28c%29git/some-repo")

    server.succeed(
        "git clone http://git:password@localhost/%28c%29git/some-repo && diff -u reference/date.txt some-repo/date.txt"
    )
  '';
})
