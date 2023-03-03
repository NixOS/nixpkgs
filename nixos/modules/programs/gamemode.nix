{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.gamemode;
  settingsFormat = pkgs.formats.ini { };
  configFile = settingsFormat.generate "gamemode.ini" cfg.settings;
in
{
  options = {
    programs.gamemode = {
      enable = mkEnableOption (lib.mdDoc "GameMode to optimise system performance on demand");

      enableRenice = mkEnableOption (lib.mdDoc "CAP_SYS_NICE on gamemoded to support lowering process niceness") // {
        default = true;
      };

      settings = mkOption {
        type = settingsFormat.type;
        default = {};
        description = lib.mdDoc ''
          System-wide configuration for GameMode (/etc/gamemode.ini).
          See gamemoded(8) man page for available settings.
        '';
        example = literalExpression ''
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

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ pkgs.gamemode ];
      etc."gamemode.ini".source = configFile;
    };

    security = {
      polkit.enable = true;
      wrappers = mkIf cfg.enableRenice {
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
        environment.PATH = mkForce (pkgs.linkFarm "pkexec" [
          {
            name = "pkexec";
            path = "${config.security.wrapperDir}/pkexec";
          }
        ]);

        serviceConfig.ExecStart = mkIf cfg.enableRenice [
          "" # Tell systemd to clear the existing ExecStart list, to prevent appending to it.
          "${config.security.wrapperDir}/gamemoded"
        ];
      };
    };
  };

  meta = {
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
