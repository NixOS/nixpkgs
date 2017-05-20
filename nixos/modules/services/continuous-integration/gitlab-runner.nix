{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gitlab-runner;
  configFile = pkgs.writeText "config.toml" cfg.configText;
  hasDocker = config.virtualisation.docker.enable;
in
{
  options.services.gitlab-runner = {
    enable = mkEnableOption "Gitlab Runner";

    configText = mkOption {
      description = "Verbatim config.toml to use";
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

  };

  config = mkIf cfg.enable {
    systemd.services.gitlab-runner = {
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
      };
    };

    # Make the gitlab-runner command availabe so users can query the runner
    environment.systemPackages = [ cfg.package ];

    users.extraUsers.gitlab-runner = {
      group = "gitlab-runner";
      extraGroups = optional hasDocker "docker";
      uid = config.ids.uids.gitlab-runner;
      home = cfg.workDir;
      createHome = true;
    };

    users.extraGroups.gitlab-runner.gid = config.ids.gids.gitlab-runner;
  };
}
