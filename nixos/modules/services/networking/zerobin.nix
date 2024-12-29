{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.zerobin;

  zerobin_config = pkgs.writeText "zerobin-config.py" ''
    PASTE_FILES_ROOT = "${cfg.dataDir}"
    ${cfg.extraConfig}
  '';

in
{
  options = {
    services.zerobin = {
      enable = lib.mkEnableOption "0bin";

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/zerobin";
        description = ''
          Path to the 0bin data directory
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "zerobin";
        description = ''
          The user 0bin should run as
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "zerobin";
        description = ''
          The group 0bin should run as
        '';
      };

      listenPort = lib.mkOption {
        type = lib.types.int;
        default = 8000;
        example = 1357;
        description = ''
          The port zerobin should listen on
        '';
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        example = "127.0.0.1";
        description = ''
          The address zerobin should listen to
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = ''
          MENU = (
          ('Home', '/'),
          )
          COMPRESSED_STATIC_FILE = True
        '';
        description = ''
          Extra configuration to be appended to the 0bin config file
          (see https://0bin.readthedocs.org/en/latest/en/options.html)
        '';
      };
    };
  };

  config = lib.mkIf (cfg.enable) {
    users.users.${cfg.user} = lib.optionalAttrs (cfg.user == "zerobin") {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
    };
    users.groups.${cfg.group} = { };

    systemd.services.zerobin = {
      enable = true;
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.zerobin}/bin/zerobin ${cfg.listenAddress} ${toString cfg.listenPort} false ${cfg.user} ${cfg.group} ${zerobin_config}";
      serviceConfig.PrivateTmp = "yes";
      serviceConfig.User = cfg.user;
      serviceConfig.Group = cfg.group;
      preStart = ''
        mkdir -p ${cfg.dataDir}
        chown ${cfg.user} ${cfg.dataDir}
      '';
    };
  };
}
