{ config, pkgs, lib, options, ... }:
with lib;
let
  json = pkgs.formats.json {};
  cfg = config.services.iSponsorBlockTV;
  opt = options.services.iSponsorBlockTV;
  deviceOpts = { ... }: {
    options = {
      screen_id = mkOption {
        type = types.str;
        description = "ID of the device";
      };
      name = mkOption {
        type = types.str;
        description = "Name of the device";
      };
      offset = mkOption {
        type = types.int;
        default = 0;
        description = "offset of the device (not sure what's it's used for).";
      };
    };
  };

  confFile = json.generate "config.json" cfg.settings;

in
{
  options = {
    services.iSponsorBlockTV = {
      enable = mkEnableOption "Enable iSponsorBlockTV";
      package = mkPackageOption pkgs "iSponsorBlockTV" {};

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/iSponsorBlockTV";
        description = "Directory where to store configuration";
      };

      user = mkOption {
        type = types.str;
        default = "iSponsorBlockTV";
        description = "User account under which iSponsorBlockTV runs.";
      };

      group = mkOption {
        type = types.str;
        default = "iSponsorBlockTV";
        description = "group account under which iSponsorBlockTV runs.";
      };

      skip_ads = mkEnableOption "Skip ads whenever it's possible";
      mute_ads = mkEnableOption "Mute ads";
      skip_count_tracking = mkEnableOption "Skip count tracking";

      settings = mkOption {
        description = "iSponsorBlockTV settings";
        default = {};
        type = types.submodule {
           freeformType = json.type;

          options.apikey = mkOption {
            type = types.str;
            default = "";
            description = "Youtube API key";
          };

          options.skip_categories = mkOption {
            type = types.listOf (types.enum ([
              "sponsor"
              "selfpromo"
              "intro"
              "outro"
              "music_offtopic"
              "interaction"
              "exclusive_access"
              "poi_highlight"
              "preview"
              "filler"
            ]));
            default = [];
            description = "List of categories to skip automatically";
          };

          options.devices = mkOption {
            type = types.listOf (types.submodule deviceOpts);
            default = [];
            description = ''List of devices.
              Run iSponsorBlockTV --data-dir /tmp --setup to link to your devices.
              Check content of /tmp/config.json
            '';
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    assertions = [
      {
        assertion = length cfg.settings.devices > 0;
        message = "At least 1 device must be set in settings.devices";
      }
    ];

    users.users = optionalAttrs (cfg.user == "iSponsorBlockTV") ({
      iSponsorBlockTV = {
        isSystemUser = true;
        group = cfg.group;
        uid = config.ids.uids.iSponsorBlockTV;
        description = "iSponsorBlockTV user";
        home = cfg.dataDir;
        createHome = true;
      };
    });

    users.groups = optionalAttrs (cfg.group == "iSponsorBlockTV") ({
      iSponsorBlockTV = {
        gid = config.ids.gids.iSponsorBlockTV;
      };
    });

    systemd.services.iSponsorBlockTV = {
      description = "Skip sponsor segments in YouTube videos playing on a YouTube TV device";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${getExe cfg.package} --data-dir ${cfg.dataDir}";
        User = cfg.user;
        Group = cfg.group;
      };

      preStart = ''
        ln -fs ${confFile} ${cfg.dataDir}/config.json
      '';
    };
  };
}
