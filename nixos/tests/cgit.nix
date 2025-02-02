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
            path = "/tmp/git/some-repo";
            desc = "some-repo description";
          };
        };
        settings = {
          readme = [
            ":README.md"
            ":date.txt"
          ];
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

    server.succeed("sudo -u cgit ${pkgs.writeShellScript "setup-cgit-test-repo" ''
      set -e
      git init --bare -b master /tmp/git/some-repo
      git init -b master reference
      cd reference
      git remote add origin /tmp/git/some-repo
      { echo -n "cgit NixOS Test at "; date; } > date.txt
      git add date.txt
      git -c user.name=test -c user.email=test@localhost commit -m 'add date'
      git push -u origin master
    ''}")

    # test web download
    server.succeed(
        "curl -fsS 'http://localhost/%28c%29git/some-repo/plain/date.txt?id=master' | diff -u reference/date.txt -"
    )

    # test http clone
    server.succeed(
       "git clone http://localhost/%28c%29git/some-repo && diff -u reference/date.txt some-repo/date.txt"
    )

    # test list settings by greping for the fallback readme
    server.succeed(
        "curl -fsS 'http://localhost/%28c%29git/some-repo/about/' | grep -F 'cgit NixOS Test at'"
    )

    # add real readme
    server.succeed("sudo -u cgit ${pkgs.writeShellScript "cgit-commit-readme" ''
      set -e
      echo '# cgit NixOS test README' > reference/README.md
      git -C reference add README.md
      git -C reference -c user.name=test -c user.email=test@localhost commit -m 'add readme'
      git -C reference push
    ''}")

    # test list settings by greping for the real readme
    server.succeed(
        "curl -fsS 'http://localhost/%28c%29git/some-repo/about/' | grep -F '# cgit NixOS test README'"
    )
    server.fail(
        "curl -fsS 'http://localhost/%28c%29git/some-repo/about/' | grep -F 'cgit NixOS Test at'"
    )
  '';
})
