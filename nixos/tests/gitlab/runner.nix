{
  pkgs,
  lib,
  ...
}:

let
  initialRootPassword = "notproduction";
  runnerTokenFile = "/run/secrets/gitlab-runner/token.env";
in
{
  name = "gitlab-runner";
  meta.maintainers = with lib.maintainers; [
    gabyx
  ];

  nodes = {
    gitlab-runner =
      { ... }:
      {
        # Define the Gitlab Runner.
        services.gitlab-runner = {
          enable = true;

          services.nix-runner = {
            description = "NixOS Shell Executor";
            authenticationTokenConfigFile = runnerTokenFile;
            executor = "shell";
          };

          settings = {
            log_level = "info";
          };

          gracefulTermination = false;
        };
      };
    gitlab =
      { config, ... }:
      {

        imports = [ ../common/user-account.nix ];

        networking.firewall.allowedTCPPorts = [
          config.services.nginx.defaultHTTPListenPort
        ];

        environment.systemPackages = with pkgs; [ git ];

        virtualisation.memorySize = 6144;
        virtualisation.cores = 4;
        # virtualisation.useNixStoreImage = true;

        systemd.services.gitlab.serviceConfig.Restart = lib.mkForce "no";
        systemd.services.gitlab-workhorse.serviceConfig.Restart = lib.mkForce "no";
        systemd.services.gitaly.serviceConfig.Restart = lib.mkForce "no";
        systemd.services.gitlab-sidekiq.serviceConfig.Restart = lib.mkForce "no";

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
          secrets = {
            secretFile = pkgs.writeText "secret" "Aig5zaic";
            otpFile = pkgs.writeText "otpsecret" "Riew9mue";
            dbFile = pkgs.writeText "dbsecret" "we2quaeZ";
            jwsFile = pkgs.runCommand "oidcKeyBase" { } "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
            activeRecordPrimaryKeyFile = pkgs.writeText "arprimary" "vsaYPZjTRxcbG7W6gNr95AwBmzFUd4Eu";
            activeRecordDeterministicKeyFile = pkgs.writeText "ardeterministic" "kQarv9wb2JVP7XzLTh5f6DFcMHms4nEC";
            activeRecordSaltFile = pkgs.writeText "arsalt" "QkgR9CfFU3MXEWGqa7LbP24AntK5ZeYw";
          };

          # reduce memory usage
          sidekiq.concurrency = 1;
          puma.workers = 2;
        };
      };
  };

  testScript =
    { nodes, ... }:
    let
      auth = pkgs.writeText "auth.json" (
        builtins.toJSON {
          grant_type = "password";
          username = "root";
          password = initialRootPassword;
        }
      );

      runnerTokenTmpl = pkgs.writeText "runner-token.env" ''
        CI_SERVER_URL=http://gitlab
        CI_SERVER_TOKEN=$token
      '';

      createRunner = pkgs.writeText "create-runner.json" (
        builtins.toJSON {
          runner_type = "instance_type";
        }
      );

      # Wait for all GitLab services to be fully started.
      waitForServices = ''
        gitlab.wait_for_unit("gitaly.service")
        gitlab.wait_for_unit("gitlab-workhorse.service")
        gitlab.wait_for_unit("gitlab.service")
        gitlab.wait_for_unit("gitlab-sidekiq.service")
        gitlab.wait_for_file("${nodes.gitlab.services.gitlab.statePath}/tmp/sockets/gitlab.socket")
        gitlab.wait_until_succeeds("curl -sSf http://gitlab/users/sign_in")
      '';
    in
    # python
    ''
      start_all()
    ''
    + waitForServices
    +
      # python
      ''
        import os
        import json
        from pathlib import Path
        from string import Template

        gitlab.succeed("cp /var/gitlab/state/config/secrets.yml /root/gitlab-secrets.yml")

        gitlab.succeed(
            "echo \"Authorization: Bearer $(curl -X POST -H 'Content-Type: application/json' -d @${auth} http://gitlab/oauth/token | ${pkgs.jq}/bin/jq -r '.access_token')\" >/tmp/headers"
        )

        gitlab.copy_from_vm("/tmp/headers")
        out_dir = os.environ.get("out", os.getcwd())
        gitlab_runner.copy_from_host(str(Path(out_dir, "headers")), "/tmp/headers")

        # Test connection.
        gitlab_runner.succeed("curl -v -H @/tmp/headers http://gitlab/api/v4/version")

        # Create runner.
        resp = gitlab.execute("""
          curl -s -X POST \
            -H 'Content-Type: application/json' \
            -H @/tmp/headers \
            -d @${createRunner} \
            http://gitlab/api/v4/user/runners
        """)[1]
        runnerObj = json.loads(resp)
        runnerID = runnerObj["id"]
        token = runnerObj["token"]

        # Push the token to the runner machine.
        tokenF = Path(out_dir, "token.env")
        with open("${runnerTokenTmpl}", "r") as f:
            tokenData = Template(f.read()).substitute({"token": token})
        with open(tokenF, "w") as w:
            w.write(tokenData)

        gitlab_runner.copy_from_host(str(tokenF), "${runnerTokenFile}")

        # Restart the runner to pick up the token.
        gitlab_runner.systemctl("restart gitlab-runner.service")
        gitlab_runner.wait_for_unit("gitlab-runner.service")

        resp = gitlab.execute(f"""
          curl -s -X GET \
            -H 'Content-Type: application/json' \
            -H @/tmp/headers \
            http://gitlab/api/v4/runners/{runnerID}
        """)[1]
        runnerStatus = json.loads(resp)

        if not runnerStatus["active"]:
            raise Exception(f"Runner status is not active: {resp}")
      '';
}
