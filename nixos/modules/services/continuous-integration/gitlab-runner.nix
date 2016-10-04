{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gitlab-runner;
  configFile = pkgs.writeText "config.toml" cfg.configText;
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

  };

  config = mkIf cfg.enable {
    systemd.services.gitlab-runner = {
      description = "Gitlab Runner";
      after = [ "network.target" "docker.service" ];
      requires = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''${pkgs.gitlab-runner.bin}/bin/gitlab-runner run \
          --working-directory ${cfg.workDir} \
          --config ${configFile} \
          --service gitlab-runner \
          --user gitlab-runner \
        '';
      };
    };

    users.extraUsers.gitlab-runner = {
      group = "gitlab-runner";
      extraGroups = [ "docker" ];
      uid = config.ids.uids.gitlab-runner;
      home = cfg.workDir;
      createHome = true;
    };

    users.extraGroups.gitlab-runner.gid = config.ids.gids.gitlab-runner;
  };
}
