# This test runs a gitlab-runner and performs the following tests in
# two machines `gitlab` and `gitlab-runner`:
# - Create runners in the `gitlab` machine for all runners in `./runner`.
# - Inject the runner tokens into the `gitlab-runner.service` (machine `gitlab-runner`)
#   which runs all runners:
#     - Shell runner in `./runner/shell-runner`.
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
    shell = {
      enabled = true; # Works on all systems.
      desc = "Shell runner (host NixOS shell, host Nix store)";
      name = "shell";
      path = ./runner/shell-runner.nix;
      tokenFile = "${runnerTokenDir}/token-shell.env";
    };

    # The Gitlab runner which uses the Docker runner (we use podman).
    # Features:
    #  - Daemonizes the Nix store into a container.
    #  - All jobs run in an unprivileged container, e.g. with image
    #    (`local/nix`, `local/alpine`, `local/ubuntu`)
    podman = {
      # Only enabled on x86_64-linux: due to container images.
      # TODO: See https://github.com/NixOS/nixpkgs/issues/474409
      enabled = pkgs.stdenv.buildPlatform.isx86_64;
      desc = "Podman runner (containers, shared containerized Nix store)";
      name = "podman";
      path = ./runner/podman-runner;
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
      { ... }:
      {
        imports = [
          ../common/user-account.nix
        ]
        # Include all runners which are enabled.
        ++ (lib.mapAttrsToList (
          k: runnerConfig:
          import runnerConfig.path {
            inherit runnerConfig;
          }
        ) (lib.filterAttrs (k: runnerCfg: runnerCfg.enabled) runnerConfigs));

        virtualisation = {
          diskSize = 10000;
        };

        # Define the Gitlab Runner.
        services.gitlab-runner = {
          enable = true;

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
      authPayload = pkgs.writeText "auth.json" (
        builtins.toJSON {
          grant_type = "password";
          username = "root";
          password = initialRootPassword;
        }
      );

      runnerTokenEnv = pkgs.writeText "runner-token.env" ''
        CI_SERVER_URL=http://gitlab
        CI_SERVER_TOKEN=$token
      '';

      createRunnerPayload = pkgs.writeText "create-runner.json" (
        builtins.toJSON {
          runner_type = "instance_type";
        }
      );
    in
    # python
    ''
      # Define some globals for the python script below.
      JQ_BINARY="${pkgs.jq}/bin/jq"
      GITLAB_STATE_PATH="${nodes.gitlab.services.gitlab.statePath}"
      RUNNER_TOKEN_ENV_FILE="${runnerTokenEnv}"
      AUTH_PAYLOAD_FILE="${authPayload}"
      CREATE_RUNNER_PAYLOAD_FILE="${createRunnerPayload}"

      ${lib.readFile ./runner_test.py}

      start_all()
      wait_for_services()

      # Run all tests.
      test_connection()

      # Register all runners which are enabled.
      for name, tokenFile, enabled in [
          ("shell", "${runnerConfigs.shell.tokenFile}", "${lib.boolToString runnerConfigs.shell.enabled}"),
          ("podman", "${runnerConfigs.podman.tokenFile}", "${lib.boolToString runnerConfigs.podman.enabled}")]:
        if enabled == "true":
          test_register_runner(name=name, tokenFile=tokenFile)

      restart_gitlab_runner_service(runnerConfigs)

      for config in runnerConfigs.values():
        test_runner_registered(config)
    '';
}
