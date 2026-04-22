{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.motioneye;
in
{
  options.services.motioneye = {
    enable = lib.mkEnableOption "motionEye";

    packages = {
      motioneye = lib.mkPackageOption pkgs "motioneye" { };
      motion = lib.mkPackageOption pkgs "motion" { };
      ffmpeg = lib.mkPackageOption pkgs "ffmpeg" { };
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "motioneye";
      description = "User to run motionEye under.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "motioneye";
      description = "Group to run motionEye under.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      defaultText = lib.literalExpression /* nix */ ''
        {
          conf_path = lib.mkDefault "/var/lib/motioneye/conf";
          run_path = lib.mkDefault "/run/motioneye";
          log_path = lib.mkDefault "/var/log/motioneye";
          media_path = lib.mkDefault "/var/lib/motioneye/media";
        }
      '';
      description = ''
        Configuration to put in motioneye.conf.
        See <https://github.com/motioneye-project/motioneye/wiki/Configuration-File>  for more details.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.motioneye.settings = {
      conf_path = lib.mkDefault "/var/lib/motioneye/conf";
      run_path = lib.mkDefault "/run/motioneye";
      log_path = lib.mkDefault "/var/log/motioneye";
      media_path = lib.mkDefault "/var/lib/motioneye/media";
    };

    users = {
      groups.${cfg.group} = { };
      users.${cfg.user} = {
        inherit (cfg) group;
        isSystemUser = true;

        # allow v4l access
        extraGroups = [ "video" ];
      };
    };

    systemd.tmpfiles.settings.motioneye =
      let
        config = {
          d = {
            inherit (cfg) user group;
            mode = "0750";
          };
        };
      in
      {
        "${cfg.settings.conf_path}" = config;
        "${cfg.settings.run_path}" = config;
        "${cfg.settings.log_path}" = config;
        "${cfg.settings.media_path}" = config;
      };

    environment.etc."motioneye/motioneye.conf".text = lib.concatMapAttrsStringSep "\n" (
      key: value: "${key} ${lib.escapeShellArg value}"
    ) cfg.settings;

    # https://github.com/motioneye-project/motioneye/blob/main/motioneye/extra/motioneye.systemd
    systemd.services.motioneye = {
      description = "motionEye Server";
      after = [
        "network.target"
        "local-fs.target"
        "remote-fs.target"
      ];
      wantedBy = [ "multi-user.target" ];
      path =
        (with pkgs; [
          which
          v4l-utils
        ])
        ++ [
          cfg.packages.motion
          cfg.packages.ffmpeg
        ];
      restartTriggers = [
        config.environment.etc."motioneye/motioneye.conf".source
      ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        RuntimeDirectory = "motioneye";
        LogsDirectory = "motioneye";
        StateDirectory = "motioneye";
        ExecStart = "${lib.getExe' cfg.packages.motioneye "meyectl"} startserver -c /etc/motioneye/motioneye.conf";
        Restart = "on-abort";
      };
    };
  };
}
