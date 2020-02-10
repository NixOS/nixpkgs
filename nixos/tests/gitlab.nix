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
        registry = {
          enable = true;
          certFile = pkgs.writeText "registry.crt" ''
          -----BEGIN CERTIFICATE-----
          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
          phjzWhY=
          -----END CERTIFICATE-----
          '';
          keyFile = pkgs.writeText "registry.key" ''
          -----BEGIN RSA PRIVATE KEY-----
          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
          -----END RSA PRIVATE KEY-----
          '';
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
    gitlab.succeed(
        "curl -H @/tmp/headers http://gitlab:4567"
    )
  '';
})
