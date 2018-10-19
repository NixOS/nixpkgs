{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.lirc;
in {

  ###### interface

  options = {
    services.lirc = {

      enable = mkEnableOption "LIRC daemon";

      options = mkOption {
        type = types.lines;
        example = ''
          [lircd]
          nodaemon = False
        '';
        description = "LIRC default options descriped in man:lircd(8) (<filename>lirc_options.conf</filename>)";
      };

      configs = mkOption {
        type = types.listOf types.lines;
        description = "Configurations for lircd to load, see man:lircd.conf(5) for details (<filename>lircd.conf</filename>)";
      };

      extraArguments = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Extra arguments to lircd.";
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    # Note: LIRC executables raises a warning, if lirc_options.conf do not exists
    environment.etc."lirc/lirc_options.conf".text = cfg.options;

    environment.systemPackages = [ pkgs.lirc ];

    systemd.sockets.lircd = {
      description = "LIRC daemon socket";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = "/run/lirc/lircd";
        SocketUser = "lirc";
        SocketMode = "0660";
      };
    };

    systemd.services.lircd = let
      configFile = pkgs.writeText "lircd.conf" (builtins.concatStringsSep "\n" cfg.configs);
    in {
      description = "LIRC daemon service";
      after = [ "network.target" ];

      unitConfig.Documentation = [ "man:lircd(8)" ];

      serviceConfig = {
        RuntimeDirectory = "lirc";

        # socket lives in runtime directory; we have to keep is available
        RuntimeDirectoryPreserve = true;

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
