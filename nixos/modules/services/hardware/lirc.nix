{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.lirc;
in {

  ###### interface

  options = {
    services.lirc = {

      enable = mkEnableOption (lib.mdDoc "LIRC daemon");

      options = mkOption {
        type = types.lines;
        example = ''
          [lircd]
          nodaemon = False
        '';
        description = lib.mdDoc "LIRC default options described in man:lircd(8) ({file}`lirc_options.conf`)";
      };

      configs = mkOption {
        type = types.listOf types.lines;
        description = lib.mdDoc "Configurations for lircd to load, see man:lircd.conf(5) for details ({file}`lircd.conf`)";
      };

      extraArguments = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc "Extra arguments to lircd.";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    # Note: LIRC executables raises a warning, if lirc_options.conf do not exists
    environment.etc."lirc/lirc_options.conf".text = cfg.options;

    environment.systemPackages = [ pkgs.lirc ];

    systemd.services.lircd = let
      configFile = pkgs.writeText "lircd.conf" (builtins.concatStringsSep "\n" cfg.configs);
    in {
      description = "LIRC daemon service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      unitConfig.Documentation = [ "man:lircd(8)" ];

      serviceConfig = {
        RuntimeDirectory = ["lirc" "lirc/lock"];

        ExecStart = ''
          ${pkgs.lirc}/bin/lircd --nodaemon \
            ${escapeShellArgs cfg.extraArguments} \
            ${configFile}
        '';
        User = "lirc";
      };
    };

    users.users.lirc = {
      uid = config.ids.uids.lirc;
      group = "lirc";
      description = "LIRC user for lircd";
    };

    users.groups.lirc.gid = config.ids.gids.lirc;
  };
}
