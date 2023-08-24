{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.irexec;
in {

  ###### interface

  options = {
    services.irexec = {

      enable = mkEnableOption "Handle events from IR remotes decoded by lircd(8)";

      configs = mkOption {
        type = types.nullOr types.lines;
        description = "Configurations for irexec to load, see man:irexec(1) for details (<filename>irexec.lircrc</filename>)";
        example = ''
          #
          # Initial test configuration for systemwide irexec service.
          #
          # Note that the system-wide service is useful only in corner-cases.
          # Most scenarios are better off with a session service as described in the
          # Configuration Guide. However, note that both can also be combined.
          #
          # Also note that the system-wide service runs without a terminal. To
          # check the output generated use something like
          # 'journalctl -b0 /usr/bin/irexec'. This service just echoes some keys
          # commonly available.
          #

          begin
              prog   = irexec
              button = KEY_RED
              config = echo "KEY_RED"
          end

          begin
              prog   = irexec
              button = KEY_BLUE
              config = echo "KEY_BLUE"
          end

          begin
              prog   = irexec
              button = KEY_1
              config = echo "KEY_1"
          end

          begin
              prog   = irexec
              button = KEY_2
              config = echo "KEY_2"
          end

          begin
              prog   = irexec
              button = KEY_3
              config = echo "KEY_3"
          end

          begin
              prog   = irexec
              button = KEY_OK
              config = echo "KEY_OK"
          end

          begin
              prog   = irexec
              button = KEY_LEFT
              config = echo "KEY_LEFT"
          end

          begin
              prog   = irexec
              button = KEY_RIGHT
              config = echo "KEY_RIGHT"
          end


        '';
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.etc."lirc/irexec.lircrc".text = cfg.configs;

    environment.systemPackages = [ pkgs.lirc ];

    systemd.services.irexec = let
      configFile = pkgs.writeText "irexec.lircrc" (cfg.configs);
    in {
      description = "Handle events from IR remotes decoded by lircd(8)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      unitConfig.Documentation = [ "man:irexec(1)" "http://lirc.org/html/configure.html" "http://lirc.org/html/configure.html#lircrc_format" ];

      serviceConfig = {
        RuntimeDirectory = ["lirc" "lirc/lock"];
        RuntimeDirectoryPreserve = true;
        PermissionsStartOnly = true;
        ExecStartPre = [
          "${pkgs.coreutils}/bin/chown lirc /run/lirc/"
        ];
        ExecStart = ''
          ${pkgs.lirc}/bin/irexec ${configFile}
        '';
      };
    };

  };
}
