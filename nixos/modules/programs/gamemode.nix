{ config, lib, pkgs, ... }:

let
  cfg = config.programs.gamemode;
  settingsFormat = pkgs.formats.ini { };
  configFile = settingsFormat.generate "gamemode.ini" cfg.settings;
in
{
  options = {
    programs.gamemode = {
      enable = lib.mkEnableOption "GameMode to optimise system performance on demand";

      enableRenice = lib.mkEnableOption "CAP_SYS_NICE on gamemoded to support lowering process niceness" // {
        default = true;
      };

      start = lib.mkOption {
        type = with lib.types; attrsOf str;
        description = ''
          Bash scripts to run when gamemode starts.

          Ordering depends on alphabetical order of the script names.
        '';
        example = {
          myScript = ''
            echo "Gamemode has started!"
            echo "You can run arbitrary commands here"
          '';
          myZZZScript = ''
            echo "This runs after myScript"
          '';
        };
        default = { };
      };

      end = lib.mkOption {
        type = with lib.types; attrsOf str;
        description = ''
          Bash scripts to run when gamemode ends.

          Ordering depends on alphabetical order of the script names.
        '';
        example = {
          myScript = ''
            echo "Gamemode has ended!"
            echo "You can run arbitrary commands here"
          '';
          myZZZScript = ''
            echo "This runs after myScript"
          '';
        };
        default = { };
      };

      settings = lib.mkOption {
        type = settingsFormat.type;
        default = { };
        description = ''
          System-wide configuration for GameMode (/etc/gamemode.ini).
          See gamemoded(8) man page for available settings.
        '';
        example = lib.literalExpression ''
          {
            general = {
              renice = 10;
            };

            # Warning: GPU optimisations have the potential to damage hardware
            gpu = {
              apply_gpu_optimisations = "accept-responsibility";
              gpu_device = 0;
              amd_performance_level = "high";
            };

            custom = {
              start = "''${pkgs.libnotify}/bin/notify-send 'GameMode started'";
              end = "''${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
            };
          }
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ pkgs.gamemode ];
      etc."gamemode.ini".source = configFile;
    };

    security = {
      polkit.enable = true;
      wrappers = lib.mkIf cfg.enableRenice {
        gamemoded = {
          owner = "root";
          group = "root";
          source = "${pkgs.gamemode}/bin/gamemoded";
          capabilities = "cap_sys_nice+ep";
        };
      };
    };

    systemd = {
      packages = [ pkgs.gamemode ];
      user.services.gamemoded = {
        # The upstream service already defines this, but doesn't get applied.
        # See https://github.com/NixOS/nixpkgs/issues/81138
        wantedBy = [ "default.target" ];

        # Use pkexec from the security wrappers to allow users to
        # run libexec/cpugovctl & libexec/gpuclockctl as root with
        # the the actions defined in share/polkit-1/actions.
        #
        # This uses a link farm to make sure other wrapped executables
        # aren't included in PATH.
        environment.PATH = lib.mkForce (pkgs.linkFarm "pkexec" [
          {
            name = "pkexec";
            path = "${config.security.wrapperDir}/pkexec";
          }
        ]);

        serviceConfig.ExecStart = lib.mkIf cfg.enableRenice [
          "" # Tell systemd to clear the existing ExecStart list, to prevent appending to it.
          "${config.security.wrapperDir}/gamemoded"
        ];
      };
    };

    users.groups.gamemode = { };

    programs.gamemode.settings =
      let
        mkStartStopCommand =
          scripts: type:
          lib.pipe scripts [
            (lib.mapAttrsToList pkgs.writeShellScript)
            lib.concatLines
            (pkgs.writeShellScript "gamemode-${type}.sh")
            toString
            (lib.mkIf (scripts != { }))
          ];
      in
      {
        custom = {
          start = mkStartStopCommand cfg.start "start";
          end = mkStartStopCommand cfg.end "end";
        };
      };
  };

  meta = {
    maintainers = with lib.maintainers; [ kira-bruneau ];
  };
}
