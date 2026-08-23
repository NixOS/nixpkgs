{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.caelestia-shell;

  hyprVars = pkgs.writeText "hypr-vars.lua" ''
    return {}
  '';

  hyprUser = pkgs.writeText "hypr-user.lua" ''
    -- User Hyprland configuration
  '';
in
{
  options.programs.caelestia-shell = {
    enable = lib.mkEnableOption "caelestia-shell, a fluid, morphing desktop shell for Wayland";

    package = lib.mkPackageOption pkgs "caelestia-shell" { };

    systemd = {
      enable = lib.mkEnableOption "the Caelestia Shell systemd user service";

      target = lib.mkOption {
        type = lib.types.str;
        default = "graphical-session.target";
        example = "wayland-session@Hyprland.target";
        description = ''
          The systemd user target that will automatically start the Caelestia Shell service.
        '';
      };
    };

    resizer.enable = lib.mkEnableOption "the caelestia window resizer daemon service";

    polkit = {
      enable = lib.mkEnableOption "the Polkit authentication agent for Caelestia Shell" // {
        default = true;
      };

      package = lib.mkPackageOption pkgs "polkit_gnome" { };
    };

    cursor = {
      enable = lib.mkEnableOption "the Bibata-Caelestia cursor theme" // {
        default = true;
      };

      package = lib.mkPackageOption pkgs "bibata-caelestia" { };

      theme = lib.mkOption {
        type = lib.types.str;
        default = "Bibata-Caelestia";
        example = "Bibata-Modern-Ice";
        description = ''
          The cursor theme name to set in fallback themes and session variables.
        '';
      };

      size = lib.mkOption {
        type = lib.types.ints.positive;
        default = 24;
        example = 32;
        description = ''
          Default cursor size.
        '';
      };
    };

    icons = {
      enable = lib.mkEnableOption "the Papirus icon theme for Caelestia Shell" // {
        default = true;
      };

      package = lib.mkPackageOption pkgs "papirus-icon-theme" { };

      theme = lib.mkOption {
        type = lib.types.str;
        default = "Papirus-Dark";
        example = "Papirus";
        description = ''
          The icon theme name to set in session variables.
        '';
      };
    };

    portal = {
      enable = lib.mkEnableOption "the XDG desktop portal configuration for Caelestia Shell" // {
        default = true;
      };

      extraPortals = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ pkgs.xdg-desktop-portal-gtk ];
        defaultText = lib.literalExpression "[ pkgs.xdg-desktop-portal-gtk ]";
        example = lib.literalExpression "[ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome ]";
        description = ''
          List of additional portal backends to enable for Caelestia Shell.
        '';
      };
    };

    recommendedServices = {
      enable = lib.mkEnableOption "recommended services and integrations" // {
        default = true;
        description = ''
          Whether to enable recommended services and integrations
          (Hyprland, NetworkManager, Bluetooth, I2C, Power Profiles Daemon,
          GeoClue2, and GPU Screen Recorder).
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services = {
          pipewire = {
            enable = lib.mkDefault true;
            pulse.enable = lib.mkDefault true;
          };
          upower.enable = lib.mkDefault true;
          accounts-daemon.enable = lib.mkDefault true;
          gnome.gnome-keyring.enable = lib.mkDefault true;
        };

        hardware.graphics.enable = lib.mkDefault true;
        qt.enable = lib.mkDefault true;

        security = {
          polkit.enable = lib.mkDefault true;
          rtkit.enable = lib.mkDefault true;
        };

        systemd.user = {
          tmpfiles.rules = [
            "d %h/.config/caelestia 0755 - - -"
            "C %h/.config/caelestia/hypr-vars.lua 0644 - - - ${hyprVars}"
            "C %h/.config/caelestia/hypr-user.lua 0644 - - - ${hyprUser}"
          ];

          services = {
            caelestia-shell = lib.mkIf cfg.systemd.enable {
              description = "Caelestia Shell Wayland desktop UI";
              documentation = [ "https://github.com/caelestia-dots/shell" ];
              path = [
                pkgs.procps
                pkgs.libnotify
              ]
              ++ lib.optional config.services.fprintd.enable config.services.fprintd.package
              ++ lib.optional config.services.howdy.enable config.services.howdy.package;
              partOf = [ cfg.systemd.target ];
              after = [ cfg.systemd.target ];
              wantedBy = [ cfg.systemd.target ];

              serviceConfig = {
                Type = "exec";
                ExecStart = lib.getExe cfg.package;
                Restart = "on-failure";
                RestartSec = "5s";
                TimeoutStopSec = "5s";
                Slice = "session.slice";
              };

              environment = {
                QT_QPA_PLATFORM = "wayland";
              };
            };

            caelestia-polkit-agent = lib.mkIf (cfg.polkit.enable && config.security.polkit.enable) {
              description = "Polkit authentication agent for Caelestia Shell";
              documentation = [ "https://gitlab.gnome.org/Archive/policykit-gnome" ];
              partOf = [ cfg.systemd.target ];
              after = [ cfg.systemd.target ];
              wantedBy = [ cfg.systemd.target ];

              serviceConfig = {
                Type = "simple";
                ExecStart = "${cfg.polkit.package}/libexec/polkit-gnome-authentication-agent-1";
                Restart = "on-failure";
                RestartSec = "1s";
                TimeoutStopSec = "10s";
                Slice = "session.slice";
              };
            };

            caelestia-resizer = lib.mkIf cfg.resizer.enable {
              description = "Caelestia window resizer daemon";
              documentation = [ "https://github.com/caelestia-dots/cli" ];
              partOf = [ cfg.systemd.target ];
              after = [ cfg.systemd.target ];
              wantedBy = [ cfg.systemd.target ];

              serviceConfig = {
                Type = "exec";
                ExecStart = "${lib.getExe pkgs.caelestia-cli} resizer";
                Restart = "on-failure";
                RestartSec = "5s";
                TimeoutStopSec = "5s";
              };
            };
          };
        };

        environment = {
          systemPackages = [
            cfg.package
            pkgs.caelestia-cli
            pkgs.procps
            pkgs.qtengine
            pkgs.wl-clipboard
            pkgs.cliphist
            pkgs.adw-gtk3
          ]
          ++ lib.optional (cfg.polkit.enable && config.security.polkit.enable) cfg.polkit.package
          ++ lib.optional cfg.cursor.enable cfg.cursor.package
          ++ lib.optionals cfg.icons.enable [
            cfg.icons.package
            pkgs.papirus-folders
          ]
          ++ lib.optionals cfg.recommendedServices.enable [
            pkgs.gammastep
            pkgs.trash-cli
            pkgs.hyprpicker
          ];

          etc = lib.mkIf cfg.icons.enable {
            "xdg/gtk-3.0/settings.ini".text = ''
              [Settings]
              gtk-icon-theme-name=${cfg.icons.theme}
            '';
            "xdg/gtk-4.0/settings.ini".text = ''
              [Settings]
              gtk-icon-theme-name=${cfg.icons.theme}
            '';
          };

          sessionVariables = lib.mkMerge [
            (lib.mkIf cfg.cursor.enable {
              XCURSOR_THEME = lib.mkDefault cfg.cursor.theme;
              XCURSOR_SIZE = lib.mkDefault (toString cfg.cursor.size);
              HYPRCURSOR_THEME = lib.mkDefault cfg.cursor.theme;
              HYPRCURSOR_SIZE = lib.mkDefault (toString cfg.cursor.size);
            })
            (lib.mkIf cfg.icons.enable {
              QS_ICON_THEME = lib.mkDefault cfg.icons.theme;
            })
            (lib.mkIf (config.qt.enable && config.qt.platformTheme == null) {
              QT_QPA_PLATFORMTHEME = lib.mkDefault "qtengine";
            })
          ];
        };

        xdg.icons.fallbackCursorThemes = lib.mkIf cfg.cursor.enable (lib.mkDefault [ cfg.cursor.theme ]);

        xdg.portal = lib.mkIf cfg.portal.enable {
          enable = lib.mkDefault true;
          extraPortals = cfg.portal.extraPortals;
          config = {
            hyprland.default = lib.mkDefault [
              "hyprland"
              "gtk"
            ];
          };
        };

        fonts.packages = with pkgs; [
          material-symbols
          rubik
          nerd-fonts.caskaydia-cove
        ];
      }

      (lib.mkIf cfg.recommendedServices.enable {
        programs.hyprland = {
          enable = lib.mkDefault true;
          withUWSM = lib.mkDefault true;
        };

        networking.networkmanager.enable = lib.mkDefault true;

        programs.gpu-screen-recorder.enable = lib.mkDefault true;

        hardware = {
          bluetooth.enable = lib.mkDefault true;
          i2c.enable = lib.mkDefault true;
        };

        location.provider = lib.mkDefault "geoclue2";

        services = {
          power-profiles-daemon.enable = lib.mkDefault true;
          geoclue2 = {
            enable = lib.mkDefault true;
            appConfig.gammastep = {
              isAllowed = true;
              isSystem = true;
            };
          };
        };
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [
    rachalaraj
  ];

  meta.doc = ./caelestia-shell.md;
}
