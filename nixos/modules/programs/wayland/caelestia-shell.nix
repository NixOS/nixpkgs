{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.caelestia-shell;
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

    cursor = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install and set Bibata-Caelestia as the default cursor theme.
        '';
      };

      package = lib.mkPackageOption pkgs "bibata-caelestia" { };

      theme = lib.mkOption {
        type = lib.types.str;
        default = "Bibata-Caelestia";
        description = ''
          The cursor theme name to set in fallback themes and session variables.
        '';
      };

      size = lib.mkOption {
        type = lib.types.int;
        default = 24;
        description = ''
          Default cursor size.
        '';
      };
    };

    icons = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install Papirus icon theme and papirus-folders for Caelestia Shell.
        '';
      };

      package = lib.mkPackageOption pkgs "papirus-icon-theme" { };

      theme = lib.mkOption {
        type = lib.types.str;
        default = "Papirus-Dark";
        description = ''
          The icon theme name to set in session variables.
        '';
      };
    };

    portal = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to configure xdg-desktop-portal and add xdg-desktop-portal-wormhole as the desktop portal for Caelestia Shell.
        '';
      };

      package = lib.mkPackageOption pkgs "xdg-desktop-portal-wormhole" { };
    };

    recommendedServices = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable peripheral hardware services and integrations
          (Bluetooth, I2C, Power Profiles Daemon, Geoclue2, and GPU Screen Recorder).
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.hyprland.enable = lib.mkDefault true;

        services = {
          pipewire = {
            enable = lib.mkDefault true;
            pulse.enable = lib.mkDefault true;
          };
          upower.enable = lib.mkDefault true;
          accounts-daemon.enable = lib.mkDefault true;
          gnome.gnome-keyring.enable = lib.mkDefault true;
        };
        networking.networkmanager.enable = lib.mkDefault true;

        hardware.graphics.enable = lib.mkDefault true;
        security = {
          polkit.enable = lib.mkDefault true;
          rtkit.enable = lib.mkDefault true;
        };

        systemd.user.tmpfiles.rules = [
          "d %h/.config/caelestia 0755 - - -"
          "C %h/.config/caelestia/hypr-vars.lua 0644 - - - ${pkgs.writeText "hypr-vars.lua" "return {}\n"}"
          "C %h/.config/caelestia/hypr-user.lua 0644 - - - ${pkgs.writeText "hypr-user.lua" "-- User Hyprland configuration\n"}"
        ];

        environment = {
          systemPackages = [
            cfg.package
            pkgs.caelestia-cli
            pkgs.procps
            pkgs.polkit_gnome
            (pkgs.writeShellScriptBin "polkit-gnome-authentication-agent-1" ''
              exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 "$@"
            '')
            pkgs.qtengine
            pkgs.wl-clipboard
            pkgs.cliphist
            pkgs.adw-gtk3
          ]
          ++ lib.optional cfg.cursor.enable cfg.cursor.package
          ++ lib.optionals cfg.icons.enable [
            cfg.icons.package
            pkgs.papirus-folders
          ]
          ++ lib.optionals cfg.recommendedServices.enable [
            pkgs.swappy
            pkgs.grim
            pkgs.slurp
            pkgs.gammastep
            pkgs.trash-cli
            pkgs.hyprpicker
            (pkgs.writeShellScriptBin "geoclue-demo-agent" ''
              exec ${config.services.geoclue2.package}/libexec/geoclue-2.0/demos/agent "$@"
            '')
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
          ];
        };

        xdg.icons.fallbackCursorThemes = lib.mkIf cfg.cursor.enable (lib.mkDefault [ cfg.cursor.theme ]);

        xdg.portal = lib.mkIf cfg.portal.enable {
          enable = lib.mkDefault true;
          extraPortals = [
            cfg.portal.package
            pkgs.xdg-desktop-portal-gtk
          ];
          configPackages = [ cfg.portal.package ];
          config = {
            common.default = lib.mkDefault [
              "wormhole"
              "gtk"
            ];
            hyprland.default = lib.mkDefault [
              "wormhole"
              "gtk"
            ];
          };
        };

        fonts.packages = with pkgs; [
          material-symbols
          rubik
          nerd-fonts.caskaydia-cove
          nerd-fonts.jetbrains-mono
        ];

        systemd.user.services = {
          caelestia-shell = lib.mkIf cfg.systemd.enable {
            description = "Caelestia Shell Wayland desktop UI";
            documentation = [ "https://github.com/caelestia-dots/shell" ];
            partOf = [ cfg.systemd.target ];
            after = [ cfg.systemd.target ];
            wantedBy = [ cfg.systemd.target ];

            enableDefaultPath = false;

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

          caelestia-resizer = lib.mkIf cfg.resizer.enable {
            description = "Caelestia window resizer daemon";
            documentation = [ "https://github.com/caelestia-dots/cli" ];
            partOf = [ cfg.systemd.target ];
            after = [ cfg.systemd.target ];
            wantedBy = [ cfg.systemd.target ];

            enableDefaultPath = false;

            serviceConfig = {
              Type = "exec";
              ExecStart = "${lib.getExe pkgs.caelestia-cli} resizer";
              Restart = "on-failure";
              RestartSec = "5s";
              TimeoutStopSec = "5s";
            };
          };
        };
      }

      (lib.mkIf cfg.recommendedServices.enable {
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
            enableDemoAgent = lib.mkForce true;
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
}
