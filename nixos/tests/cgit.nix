import ./make-test-python.nix (
  { pkgs, ... }:
  let
    robotsTxt = pkgs.writeText "cgit-robots.txt" ''
      User-agent: *
      Disallow: /
    '';
  in
  {
    name = "cgit";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ schnusch ];
    };

    nodes = {
      server =
        { ... }:
        {
          services.cgit = {
            enable = true;
            virtualHosts."localhost" = {
              package = pkgs.cgit.overrideAttrs (
                { postInstall, ... }:
                {
                  postInstall = ''
                    ${postInstall}
                    cp ${robotsTxt} "$out/cgit/robots.txt"
                  '';
                }
              );
              locations = {
                "/(c)git/" = {
                  repos = {
                    some-repo = {
                      path = "/var/lib/git/(c)git/some-repo";
                      desc = "some-repo description";
                    };
                  };
                  locationConfig = {
                    basicAuth = {
                      git = "password";
                    };
                  };
                };
                "/scan-path/" = {
                  scanPath = "/var/lib/git/scan-path";
                };
              };
            };
          };

          environment.systemPackages = [
            pkgs.coreutils
            pkgs.curl
            pkgs.git
          ];
        };
    };

    testScript =
      { nodes, ... }:
      ''
        import shlex
        from typing import Optional

        locations = {
            "(c)git": "git:password",
            "scan-path": None,
        }


        def curl_url(location: str, tail: str = "", auth: Optional[str] = None) -> str:
            return (
                ("" if auth is None else f"-u {shlex.quote(auth)} ")
                + shlex.quote(f"http://localhost/{location}/{tail}")
            )


        def git_url(location: str, tail: str = "", auth: Optional[str] = None) -> str:
            return shlex.quote(
                "http://"
                + ("" if auth is None else f"{auth}@")
                + f"localhost/{location}/{tail}"
            )


        start_all()

        server.wait_for_unit("nginx.service")
        server.wait_for_unit("network.target")
        server.wait_for_open_port(80)

        server.succeed("curl -fsS http://localhost/cgit.css")

        server.succeed("curl -fsS http://localhost/robots.txt | diff -u - ${robotsTxt}")

        server.fail(f"curl -fsS {curl_url('(c)git')}")
        server.succeed(f"curl -fsS {curl_url('(c)git', auth=locations['(c)git'])} | grep -F 'some-repo description'")

        for location, auth in locations.items():
            server.succeed("${pkgs.writeShellScript "setup-cgit-test-repo" ''
              set -eux
              git init --bare -b master "/var/lib/git/$1/some-repo"
              git init -b master "$1/reference"
              cd "$1/reference"
              git remote add origin "/var/lib/git/$1/some-repo"
              date > date.txt
              git add date.txt
              git -c user.name=test -c user.email=test@localhost commit -m 'add date'
              git push -u origin master
            ''} " + shlex.quote(location))

            server.succeed(
                f"curl -fsS {curl_url(location, 'some-repo/plain/date.txt?id=master', auth)} | diff -u {shlex.quote(location)}/reference/date.txt -"
            )

            server.succeed(
                f"git clone {git_url(location, 'some-repo', auth)} {shlex.quote(location)}/some-repo",
                f"diff -u {shlex.quote(location)}/reference/date.txt {shlex.quote(location)}/some-repo/date.txt"
            )

        server.fail(f"GIT_ASKPASS=true git clone {git_url('(c)git', 'some-repo')} '(c)git/some-repo-2'")
        server.succeed(f"GIT_ASKPASS=true git clone {git_url('scan-path', 'some-repo')} 'scan-path/some-repo-2'")
      '';
  }
)
