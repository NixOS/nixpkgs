# This test runs gitlab and checks if it works

let
  initialRootPassword = "notproduction";
in
import ./make-test-python.nix ({ pkgs, lib, ...} : with lib; {
  name = "gitlab";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ globin ];
  };

  nodes = {
    gitlab = { ... }: {
      imports = [ common/user-account.nix ];

      virtualisation.memorySize = if pkgs.stdenv.is64bit then 4096 else 2047;
      virtualisation.cores = 4;
      virtualisation.useNixStoreImage = true;
      systemd.services.gitlab.serviceConfig.Restart = mkForce "no";
      systemd.services.gitlab-workhorse.serviceConfig.Restart = mkForce "no";
      systemd.services.gitaly.serviceConfig.Restart = mkForce "no";
      systemd.services.gitlab-sidekiq.serviceConfig.Restart = mkForce "no";

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts = {
          localhost = {
            locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
          };
        };
      };

      services.dovecot2 = {
        enable = true;
        enableImap = true;
      };

      systemd.services.gitlab-backup.environment.BACKUP = "dump";

      services.gitlab = {
        enable = true;
        databasePasswordFile = pkgs.writeText "dbPassword" "xo0daiF4";
        initialRootPasswordFile = pkgs.writeText "rootPassword" initialRootPassword;
        smtp.enable = true;
        extraConfig = {
          incoming_email = {
            enabled = true;
            mailbox = "inbox";
            address = "alice@localhost";
            user = "alice";
            password = "foobar";
            host = "localhost";
            port = 143;
          };
          # https://github.com/NixOS/nixpkgs/issues/132295
          # pages = {
          #   enabled = true;
          #   host = "localhost";
          # };
        };
        secrets = {
          secretFile = pkgs.writeText "secret" "Aig5zaic";
          otpFile = pkgs.writeText "otpsecret" "Riew9mue";
          dbFile = pkgs.writeText "dbsecret" "we2quaeZ";
          jwsFile = pkgs.runCommand "oidcKeyBase" {} "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
        };
      };
    };
  };

  testScript = { nodes, ... }:
    let
      auth = pkgs.writeText "auth.json" (builtins.toJSON {
        grant_type = "password";
        username = "root";
        password = initialRootPassword;
      });

      createProject = pkgs.writeText "create-project.json" (builtins.toJSON {
        name = "test";
      });

      putFile = pkgs.writeText "put-file.json" (builtins.toJSON {
        branch = "master";
        author_email = "author@example.com";
        author_name = "Firstname Lastname";
        content = "some content";
        commit_message = "create a new file";
      });

      # Wait for all GitLab services to be fully started.
      waitForServices = ''
        gitlab.wait_for_unit("gitaly.service")
        gitlab.wait_for_unit("gitlab-workhorse.service")
        # https://github.com/NixOS/nixpkgs/issues/132295
        # gitlab.wait_for_unit("gitlab-pages.service")
        gitlab.wait_for_unit("gitlab-mailroom.service")
        gitlab.wait_for_unit("gitlab.service")
        gitlab.wait_for_unit("gitlab-sidekiq.service")
        gitlab.wait_for_file("${nodes.gitlab.config.services.gitlab.statePath}/tmp/sockets/gitlab.socket")
        gitlab.wait_until_succeeds("curl -sSf http://gitlab/users/sign_in")
      '';

      # The actual test of GitLab. Only push data to GitLab if
      # `doSetup` is is true.
      test = doSetup: ''
        gitlab.succeed(
            "curl -isSf http://gitlab | grep -i location | grep http://gitlab/users/sign_in"
        )
        gitlab.succeed(
            "${pkgs.sudo}/bin/sudo -u gitlab -H gitlab-rake gitlab:check 1>&2"
        )
        gitlab.succeed(
            "echo \"Authorization: Bearer \$(curl -X POST -H 'Content-Type: application/json' -d @${auth} http://gitlab/oauth/token | ${pkgs.jq}/bin/jq -r '.access_token')\" >/tmp/headers"
        )
      '' + optionalString doSetup ''
        gitlab.succeed(
            "curl -X POST -H 'Content-Type: application/json' -H @/tmp/headers -d @${createProject} http://gitlab/api/v4/projects"
        )
        gitlab.succeed(
            "curl -X POST -H 'Content-Type: application/json' -H @/tmp/headers -d @${putFile} http://gitlab/api/v4/projects/1/repository/files/some-file.txt"
        )
      '' + ''
        gitlab.succeed(
            "curl -H @/tmp/headers http://gitlab/api/v4/projects/1/repository/archive.tar.gz > /tmp/archive.tar.gz"
        )
        gitlab.succeed(
            "curl -H @/tmp/headers http://gitlab/api/v4/projects/1/repository/archive.tar.bz2 > /tmp/archive.tar.bz2"
        )
        gitlab.succeed("test -s /tmp/archive.tar.gz")
        gitlab.succeed("test -s /tmp/archive.tar.bz2")
      '';

  in ''
      gitlab.start()
    ''
    + waitForServices
    + test true
    + ''
      gitlab.systemctl("start gitlab-backup.service")
      gitlab.wait_for_unit("gitlab-backup.service")
      gitlab.wait_for_file("${nodes.gitlab.config.services.gitlab.statePath}/backup/dump_gitlab_backup.tar")
      gitlab.systemctl("stop postgresql.service gitlab.target")
      gitlab.succeed(
          "find ${nodes.gitlab.config.services.gitlab.statePath} -mindepth 1 -maxdepth 1 -not -name backup -execdir rm -r {} +"
      )
      gitlab.succeed("systemd-tmpfiles --create")
      gitlab.succeed("rm -rf ${nodes.gitlab.config.services.postgresql.dataDir}")
      gitlab.systemctl("start gitlab-config.service gitaly.service gitlab-postgresql.service")
      gitlab.wait_for_file("${nodes.gitlab.config.services.gitlab.statePath}/tmp/sockets/gitaly.socket")
      gitlab.succeed(
          "sudo -u gitlab -H gitlab-rake gitlab:backup:restore RAILS_ENV=production BACKUP=dump force=yes"
      )
      gitlab.systemctl("start gitlab.target")
    ''
    + waitForServices
    + test false;
})
