{ pkgs, lib, ... }:
{
  name = "gitwatch";
  meta.maintainers = with lib.maintainers; [ h7x4 ];

  containers.machine =
    let
      inherit (import ./ssh-keys.nix pkgs)
        snakeOilEd25519PrivateKey
        snakeOilEd25519PublicKey
        ;
    in
    {
      programs.git = {
        enable = true;
        config = {
          init.defaultBranch = "main";
          user.name = "gitwatch";
          user.email = "gitwatch@localhost";
        };
      };

      services.openssh = {
        enable = true;
        hostKeys = [
          {
            type = "ed25519";
            path = "/etc/ssh/ssh_host_ed25519_key";
          }
        ];
      };
      environment.etc."ssh/ssh_host_ed25519_key" = {
        source = snakeOilEd25519PrivateKey;
        mode = "0600";
      };
      users.users.root.openssh.authorizedKeys.keys = [ snakeOilEd25519PublicKey ];
      systemd.tmpfiles.rules = [
        "d /root/.ssh 0700 root root -"
        "C+ /root/.ssh/id_ed25519 0600 root root - ${snakeOilEd25519PrivateKey}"
      ];
      programs.ssh = {
        systemd-ssh-proxy.enable = false;
        knownHosts.localhost = {
          hostNames = [
            "localhost"
            "127.0.0.1"
          ];
          publicKey = snakeOilEd25519PublicKey;
        };
      };

      services.gitwatch = {
        file-remote = {
          enable = true;
          path = "/var/lib/gitwatch/file-remote";
          remote = "/srv/git/file-remote.git";
          branch = "main";
          message = "Auto-commit by gitwatch on %d";
        };
        ssh-remote = {
          enable = true;
          path = "/var/lib/gitwatch/ssh-remote";
          remote = "ssh://root@localhost/srv/git/ssh-remote.git";
          branch = "main";
        };
      };

      # Started by the test script, once the upstreams exist.
      systemd.services.gitwatch-file-remote.wantedBy = lib.mkForce [ ];
      systemd.services.gitwatch-ssh-remote.wantedBy = lib.mkForce [ ];
    };

  testScript = ''
    repos = ["file-remote", "ssh-remote"]

    def wait_for_upstream(repo: str, cmd: str) -> None:
        machine.wait_until_succeeds(f"git --git-dir=/srv/git/{repo}.git {cmd}")

    machine.start()
    machine.wait_for_unit("multi-user.target")

    for repo in repos:
        machine.succeed(
            f"git init --bare --initial-branch=main /srv/git/{repo}.git",
            f"git clone /srv/git/{repo}.git /tmp/{repo}",
            f"echo initial > /tmp/{repo}/README",
            f"git -C /tmp/{repo} add README",
            f"git -C /tmp/{repo} commit -m 'Initial commit'",
            f"git -C /tmp/{repo} push origin main",
            f"rm -rf /tmp/{repo}",
        )

    with subtest("Gitwatch clones the remote when started"):
        for repo in repos:
            machine.systemctl(f"start gitwatch-{repo}.service")
            machine.wait_for_file(f"/var/lib/gitwatch/{repo}/README")

    with subtest("New files are pushed upstream"):
        for repo in repos:
            machine.succeed(f"echo hello > /var/lib/gitwatch/{repo}/greeting")
            wait_for_upstream(repo, "show main:greeting | grep -q '^hello$'")

    with subtest("Modifications are pushed upstream"):
        for repo in repos:
            machine.succeed(f"echo goodbye > /var/lib/gitwatch/{repo}/greeting")
            wait_for_upstream(repo, "show main:greeting | grep -q '^goodbye$'")

    with subtest("Deletions are pushed upstream"):
        for repo in repos:
            machine.succeed(f"rm /var/lib/gitwatch/{repo}/greeting")
            wait_for_upstream(
                repo, "log -1 --name-status --format= main | grep -q '^D.greeting$'"
            )

    with subtest("The commit message is configurable"):
        # `%d` is expanded to the current date by gitwatch.
        wait_for_upstream(
            "file-remote",
            "log --format=%s main | grep -E '^Auto-commit by gitwatch on [0-9]{4}-'"
        )
        wait_for_upstream(
            "ssh-remote",
            "log --format=%s main | grep -F 'Scripted auto-commit on change'"
        )
  '';
}
