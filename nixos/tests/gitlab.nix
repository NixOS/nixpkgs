# This test runs gitlab and checks if it works

let
  initialRootPassword = "notproduction";
in
import ./make-test-python.nix ({ pkgs, lib, ...} : with lib; {
  name = "gitlab";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ globin ];
  };

  nodes = {
    gitlab = { ... }: {
      virtualisation.memorySize = if pkgs.stdenv.is64bit then 4096 else 2047;
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

      services.gitlab = {
        enable = true;
        databasePasswordFile = pkgs.writeText "dbPassword" "xo0daiF4";
        initialRootPasswordFile = pkgs.writeText "rootPassword" initialRootPassword;
        smtp.enable = true;
        secrets = {
          secretFile = pkgs.writeText "secret" "Aig5zaic";
          otpFile = pkgs.writeText "otpsecret" "Riew9mue";
          dbFile = pkgs.writeText "dbsecret" "we2quaeZ";
          jwsFile = pkgs.runCommand "oidcKeyBase" {} "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
        };
      };
    };
  };

  testScript =
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
  in
  ''
    gitlab.start()
    gitlab.wait_for_unit("gitaly.service")
    gitlab.wait_for_unit("gitlab-workhorse.service")
    gitlab.wait_for_unit("gitlab.service")
    gitlab.wait_for_unit("gitlab-sidekiq.service")
    gitlab.wait_for_file("/var/gitlab/state/tmp/sockets/gitlab.socket")
    gitlab.wait_until_succeeds("curl -sSf http://gitlab/users/sign_in")
    gitlab.succeed(
        "curl -isSf http://gitlab | grep -i location | grep -q http://gitlab/users/sign_in"
    )
    gitlab.succeed(
        "${pkgs.sudo}/bin/sudo -u gitlab -H gitlab-rake gitlab:check 1>&2"
    )
    gitlab.succeed(
        "echo \"Authorization: Bearer \$(curl -X POST -H 'Content-Type: application/json' -d @${auth} http://gitlab/oauth/token | ${pkgs.jq}/bin/jq -r '.access_token')\" >/tmp/headers"
    )
    gitlab.succeed(
        "curl -X POST -H 'Content-Type: application/json' -H @/tmp/headers -d @${createProject} http://gitlab/api/v4/projects"
    )
    gitlab.succeed(
        "curl -X POST -H 'Content-Type: application/json' -H @/tmp/headers -d @${putFile} http://gitlab/api/v4/projects/1/repository/files/some-file.txt"
    )
    gitlab.succeed(
        "curl -H @/tmp/headers http://gitlab/api/v4/projects/1/repository/archive.tar.gz > /tmp/archive.tar.gz"
    )
    gitlab.succeed(
        "curl -H @/tmp/headers http://gitlab/api/v4/projects/1/repository/archive.tar.bz2 > /tmp/archive.tar.bz2"
    )
    gitlab.succeed("test -s /tmp/archive.tar.gz")
    gitlab.succeed("test -s /tmp/archive.tar.bz2")
  '';
})
