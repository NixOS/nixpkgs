{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gitlab-runner;
  configFile =
    if (cfg.configFile == null) then
      (pkgs.runCommand "config.toml" {
        buildInputs = [ pkgs.remarshal ];
        preferLocalBuild = true;
      } ''
        remarshal -if json -of toml \
          < ${pkgs.writeText "config.json" (builtins.toJSON cfg.configOptions)} \
          > $out
      '')
    else
      cfg.configFile;
  hasDocker = config.virtualisation.docker.enable;
in
{
  options.services.gitlab-runner = {
    enable = mkEnableOption "Gitlab Runner";

    configFile = mkOption {
      default = null;
      description = ''
        Configuration file for gitlab-runner.
        Use this option in favor of configOptions to avoid placing CI tokens in the nix store.

        <option>configFile</option> takes precedence over <option>configOptions</option>.

        Warning: Not using <option>configFile</option> will potentially result in secrets
        leaking into the WORLD-READABLE nix store.
      '';
      type = types.nullOr types.path;
    };

    configOptions = mkOption {
      description = ''
        Configuration for gitlab-runner
        <option>configFile</option> will take precedence over this option.

        Warning: all Configuration, especially CI token, will be stored in a
        WORLD-READABLE file in the Nix Store.

        If you want to protect your CI token use <option>configFile</option> instead.
      '';
      type = types.attrs;
      example = {
        concurrent = 2;
        runners = [{
          name = "docker-nix-1.11";
          url = "https://CI/";
          token = "TOKEN";
          executor = "docker";
          builds_dir = "";
          docker = {
            host = "";
            image = "nixos/nix:1.11";
            privileged = true;
            disable_cache = true;
            cache_dir = "";
          };
        }];
      };
    };

    gracefulTermination = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Finish all remaining jobs before stopping, restarting or reconfiguring.
        If not set gitlab-runner will stop immediatly without waiting for jobs to finish,
        which will lead to failed builds.
      '';
    };

    gracefulTimeout = mkOption {
      default = "infinity";
      type = types.str;
      example = "5min 20s";
      description = ''Time to wait until a graceful shutdown is turned into a forceful one.'';
    };

    workDir = mkOption {
      default = "/var/lib/gitlab-runner";
      type = types.path;
      description = "The working directory used";
    };

    package = mkOption {
      description = "Gitlab Runner package to use";
      default = pkgs.gitlab-runner;
      defaultText = "pkgs.gitlab-runner";
      type = types.package;
      example = literalExample "pkgs.gitlab-runner_1_11";
    };

    packages = mkOption {
      default = [ pkgs.bash pkgs.docker-machine ];
      defaultText = "[ pkgs.bash pkgs.docker-machine ]";
      type = types.listOf types.package;
      description = ''
        Packages to add to PATH for the gitlab-runner process.
      '';
    };

  };

  config = mkIf cfg.enable {
    systemd.services.gitlab-runner = {
      path = cfg.packages;
      environment = config.networking.proxy.envVars;
      description = "Gitlab Runner";
      after = [ "network.target" ]
        ++ optional hasDocker "docker.service";
      requires = optional hasDocker "docker.service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''${cfg.package.bin}/bin/gitlab-runner run \
          --working-directory ${cfg.workDir} \
          --config ${configFile} \
          --service gitlab-runner \
          --user gitlab-runner \
        '';

      } //  optionalAttrs (cfg.gracefulTermination) {
        TimeoutStopSec = "${cfg.gracefulTimeout}";
        KillSignal = "SIGQUIT";
        KillMode = "process";
      };
    };

    # Make the gitlab-runner command availabe so users can query the runner
    environment.systemPackages = [ cfg.package ];

    users.users.gitlab-runner = {
      group = "gitlab-runner";
      extraGroups = optional hasDocker "docker";
      uid = config.ids.uids.gitlab-runner;
      home = cfg.workDir;
      createHome = true;
    };

    users.groups.gitlab-runner.gid = config.ids.gids.gitlab-runner;
  };
}
