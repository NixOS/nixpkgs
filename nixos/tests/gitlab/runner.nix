# This test runs a gitlab-runner and performs the following tests in
# two machines `gitlab` and `gitlab-runner`:
# - Create runners in the `gitlab` machine for all runners in `./runner`.
# - Inject the runner tokens into the `gitlab-runner.service` (machine `gitlab-runner`)
#   which runs all executors:
#     - Shell Executor in `./runner/shell-executor`.
# - Start the `gitlab-runner.service`.
# - Check that all runners in `gitlab` are `active`.
#
# Run with
# [nixpkgs]$ nix-build -A nixosTests.gitlab.runner

{
  pkgs,
  lib,
  ...
}:

let
  initialRootPassword = "notproduction";

  runnerTokenDir = "/run/secrets/gitlab-runner";

  runnerConfigs = {
    # The Gitlab runner where each job runs
    # on the host (not containerized and very insecure).
    "shell" = {
      desc = "Shell Executor (host NixOS shell, host Nix store)";
      name = "shell";
      tokenFile = "${runnerTokenDir}/token-shell.env";
    };

    # The Gitlab runner which uses the Docker executor (we use podman).
    # Features:
    #  - Daemonizes the Nix store into a container.
    #  - All jobs run in an unprivileged container, e.g. with image
    #    (`local/nix`, `local/alpine`, `local/ubuntu`)
    "podman" = {
      desc = "Podman Executor (containers, shared containerized Nix store)";
      name = "podman";
      tokenFile = "${runnerTokenDir}/token-podman.env";
    };
  };
in
{
  name = "gitlab-runner";
  meta.maintainers = with lib.maintainers; [
    gabyx
  ];

  nodes = {
    gitlab-runner =
      { config, lib, ... }:
      {
        # Define the Gitlab Runner.
        services.gitlab-runner = {
          enable = true;

          services.shell-executor = import ./runner/shell-executor.nix {
            runnerConfig = runnerConfigs.shell;
          };

          # TODO: Add here the container executor (podman, nixDaemon etc)
          # services.container-executor = import ./runner/container-executor.nix {
          #   inherit config lib runnerTokenFile;
          # };

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

      testSetup =
        # python
        ''
          import os
          import json
          from pathlib import Path
          from string import Template
          from dataclasses import dataclass

          print("==> Getting secrets and headers.")
          gitlab.succeed("cp /var/gitlab/state/config/secrets.yml /root/gitlab-secrets.yml")

          gitlab.succeed(
              "echo \"Authorization: Bearer $(curl -X POST -H 'Content-Type: application/json' -d @${auth} http://gitlab/oauth/token | ${pkgs.jq}/bin/jq -r '.access_token')\" >/tmp/headers"
          )

          gitlab.copy_from_vm("/tmp/headers")
          out_dir = os.environ.get("out", os.getcwd())
          gitlab_runner.copy_from_host(str(Path(out_dir, "headers")), "/tmp/headers")

          print("==> Testing connection.")
          gitlab_runner.succeed("curl -v -H @/tmp/headers http://gitlab/api/v4/version")

          # Runner config data.
          @dataclass
          class Runner:
              name: str
              desc: str
              tokenFile: str

              id: str
              token: str

          runnerConfigs: dict[str, Runner] = {}
        '';

      testRegisterRunner =
        runnerConfig:
        # python
        ''
          r = Runner(name="${runnerConfig.name}",
                     desc="${runnerConfig.desc}",
                     tokenFile="${runnerConfig.tokenFile}",
                     token="",
                     id="")
          runnerConfigs[r.name] = r

          print(f"==> Create Runner '{r.name}'")
          resp = gitlab.execute("""
            curl -s -X POST \
              -H 'Content-Type: application/json' \
              -H @/tmp/headers \
              -d @${createRunner} \
              http://gitlab/api/v4/user/runners
          """)[1]
          obj = json.loads(resp)
          r.id = obj["id"]
          r.token = obj["token"]

          # Push the token to the runner machine.
          print("==> Push runner token to machine.")
          tokenF = Path(out_dir, f"token-{r.name}.env")
          with open("${runnerTokenTmpl}", "r") as f:
              tokenData = Template(f.read()).substitute({"token": token})
          with open(tokenF, "w") as w:
              w.write(tokenData)
          gitlab_runner.copy_from_host(str(tokenF), r.tokenFile)
        '';

      restartRunnerService =
        # python
        ''
          print("==> Restart Gitlab Runner")
          gitlab_runner.systemctl("restart gitlab-runner.service")
          gitlab_runner.wait_for_unit("gitlab-runner.service")
        '';

      testRunnerConnected =
        runnerConfig:
        # python
        ''
          r = runnerConfigs["${runnerConfig.name}"]

          resp = gitlab.execute(f"""
            curl -s -X GET \
              -H 'Content-Type: application/json' \
              -H @/tmp/headers \
              http://gitlab/api/v4/runners/{r.id}
          """)[1]
          runnerStatus = json.loads(resp)

          if not runnerStatus["active"]:
              raise Exception(f"Runner '{r.name}' [id: '{r.id}'] status is not active: {resp}")
        '';
    in
    # python
    ''
      start_all()
    ''
    + waitForServices
    + testSetup
    + (testRegisterRunner runnerConfigs.shell)
    + restartRunnerService
    + (testRunnerConnected runnerConfigs.shell);
}
