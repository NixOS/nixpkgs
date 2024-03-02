import ./make-test-python.nix ({ pkgs, ... }:

let
  hashes = pkgs.writeText "hashes" ''
    b5bb9d8014a0f9b1d61e21e796d78dccdf1352f23cd32812f4850b878ae4944c  /project/bar
  '';
in {
  name = "gitdaemon";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ tilpner ];
  };

  nodes = {
    server =
      { config, ... }: {
        networking.firewall.allowedTCPPorts = [ config.services.gitDaemon.port ];

        environment.systemPackages = [ pkgs.git ];

        systemd.tmpfiles.rules = [
          # type path mode user group age arg
          " d    /git 0755 root root  -   -"
        ];

        services.gitDaemon = {
          enable = true;
          basePath = "/git";
        };
      };

    client =
      { pkgs, ... }: {
        environment.systemPackages = [ pkgs.git ];
      };
  };

  testScript = ''
    start_all()

    with subtest("create project.git"):
        server.succeed(
            "git init --bare /git/project.git",
            "touch /git/project.git/git-daemon-export-ok",
        )

    with subtest("add file to project.git"):
        server.succeed(
            "git clone /git/project.git /project",
            "echo foo > /project/bar",
            "git config --global user.email 'you@example.com'",
            "git config --global user.name 'Your Name'",
            "git -C /project add bar",
            "git -C /project commit -m 'quux'",
            "git -C /project push",
            "rm -r /project",
        )

    with subtest("git daemon starts"):
        server.wait_for_unit("git-daemon.service")


    server.systemctl("start network-online.target")
    client.systemctl("start network-online.target")
    server.wait_for_unit("network-online.target")
    client.wait_for_unit("network-online.target")

    with subtest("client can clone project.git"):
        client.succeed(
            "git clone git://server/project.git /project",
            "sha256sum -c ${hashes}",
        )
  '';
})
