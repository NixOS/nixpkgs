{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.moodle-dl;
  json = pkgs.formats.json {};
  moodle-dl-json = json.generate "moodle-dl.json" cfg.settings;
  stateDirectoryDefault = "/var/lib/moodle-dl";
in {
  options = {
    services.moodle-dl = {
      enable = mkEnableOption "moodle-dl, a Moodle downloader";

      settings = mkOption {
        default = {};
        type = json.type;
        description = ''
          Configuration for moodle-dl. For a full example, see
          <link xlink:href="https://github.com/C0D3D3V/Moodle-Downloader-2/wiki/Config.json"/>.
        '';
      };

      notifyOnly = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to notify about changes without downloading any files.
        '';
      };

      startAt = mkOption {
        type = with types; either str (listOf str);
        description = "When to run moodle-dl. See systemd.time(7) for the format.";
      };

      directory = mkOption {
        default = stateDirectoryDefault;
        type = types.path;
        description = ''
          The path moodle-dl should download course files to. If left
          as the default value this directory will automatically be created before
          moodle-dl runs, otherwise the sysadmin is responsible for ensuring
          the directory exists with appropriate ownership and permissions.
        '';
      };

      package = mkOption {
        default = pkgs.moodle-dl;
        type = types.package;
        description = "The moodle-dl package to use.";
      };
    };
  };

  config = mkIf cfg.enable {

    users.users.moodle-dl = {
      isSystemUser = true;
      home = cfg.directory;
    };

    users.groups.moodle-dl = {};

    systemd.services.moodle-dl = {
      description = "A Moodle downloader that downloads course content";
      wants = [ "network-online.target" ];
      serviceConfig = mkMerge [
        {
          Type = "oneshot";
          User = config.users.users.moodle-dl.name;
          Group = config.users.groups.moodle-dl.name;
          WorkingDirectory = cfg.directory;
          ExecStart = "${cfg.package}/bin/moodle-dl ${lib.optionalString cfg.notifyOnly "--without-downloading-files"}";
          ExecStartPre = "${pkgs.coreutils}/bin/ln -sfn ${toString moodle-dl-json} ${cfg.directory}/config.json";
        }
        (mkIf (cfg.directory == stateDirectoryDefault) { StateDirectory = "moodle-dl"; })
      ];
      inherit (cfg) startAt;
    };
  };

  meta.maintainers = [ maintainers.kmein ];
}
