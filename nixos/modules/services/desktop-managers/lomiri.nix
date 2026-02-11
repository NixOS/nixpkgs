{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.desktopManager.lomiri;
in
{
  options.services.desktopManager.lomiri = {
    enable = lib.mkEnableOption ''
      the Lomiri graphical shell (formerly known as Unity8)
    '';

    basics = lib.mkOption {
      internal = true;
      description = ''
        Enable basic things for getting Lomiri working.
      '';
      type = lib.types.bool;
      default = config.services.xserver.displayManager.lightdm.greeters.lomiri.enable || cfg.enable;
    };
  };

  config = lib.mkMerge [
    # Basics for getting Lomiri to work
    (lib.mkIf cfg.basics {
      environment = {
        # To override the default keyboard layout in Lomiri
        etc.${pkgs.lomiri.lomiri.passthru.etcLayoutsFile}.text =
          lib.strings.replaceStrings
            [ "," ]
            [
              "\n"
            ]
            config.services.xserver.xkb.layout;

        pathsToLink = [
          # Data
          "/share/locale" # TODO LUITK hardcoded default locale path, fix individual apps to not rely on it
          "/share/wallpapers"
        ];

        systemPackages = with pkgs.lomiri; [
          lomiri-wallpapers # default + additional wallpaper
          suru-icon-theme # basic indicator icons
        ];
      };

      # Override GSettings defaults
      programs.dconf = {
        enable = true;
        profiles.user.databases = [
          {
            settings = {
              "com/lomiri/shell/launcher" = {
                logo-picture-uri = "file://${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
                home-button-background-color = "#5277C3";
              };
            };
            lockAll = true;
          }
        ];
      };

      fonts.packages = with pkgs; [
        ubuntu-classic # Ubuntu is default font
      ];

      # Xwayland is partly hardcoded in Mir so it can't really be fully turned off, and it must be on PATH for X11 apps *and Lomiri's web browser* to work.
      # Until Mir/Lomiri can be properly used without it, force it on so everything behaves as expected.
      programs.xwayland.enable = lib.mkForce true;

      services.ayatana-indicators = {
        enable = true;
        packages = (
          with pkgs;
          [
            ayatana-indicator-session # Controls for shutting down etc
          ]
          ++ (with lomiri; [
            lomiri-indicator-datetime # Clock
          ])
        );
      };
    })

    # Full Lomiri DE
    (lib.mkIf cfg.enable {
      # We need the basic setup as well
      services.desktopManager.lomiri.basics = true;

      environment = {
        systemPackages =
          (with pkgs; [
            glib # XDG MIME-related tools identify it as GNOME, add gio for MIME identification to work
            libayatana-common
            ubports-click
          ])
          ++ (with pkgs.lomiri; [
            hfd-service
            libusermetrics
            lomiri
            lomiri-calculator-app
            lomiri-calendar-app
            lomiri-camera-app
            lomiri-clock-app
            lomiri-content-hub
            lomiri-docviewer-app
            lomiri-download-manager
            lomiri-filemanager-app
            lomiri-gallery-app
            lomiri-history-service
            lomiri-mediaplayer-app
            lomiri-music-app
            lomiri-polkit-agent
            lomiri-schemas # exposes some required dbus interfaces
            lomiri-session # wrappers to properly launch the session
            lomiri-sounds
            lomiri-system-settings
            lomiri-telephony-service
            lomiri-terminal-app
            lomiri-thumbnailer
            lomiri-url-dispatcher
            mediascanner2 # TODO possibly needs to be kicked off by graphical-session.target
            # Qt5 qtwebengine is not secure: https://github.com/NixOS/nixpkgs/pull/435067
            # morph-browser
            # Adding another browser that is known-working until Morph Browser can migrate to Qt6
            pkgs.epiphany
            qtmir # not having its desktop file for Xwayland available causes any X11 application to crash the session
            teleports
          ]);
      };

      hardware = {
        bluetooth.enable = lib.mkDefault true;
      };

      networking.networkmanager.enable = lib.mkDefault true;

      systemd.packages = with pkgs.lomiri; [
        hfd-service
        lomiri-download-manager
      ];

      services.dbus.packages = with pkgs.lomiri; [
        hfd-service
        libusermetrics
        lomiri-download-manager
      ];

      services.accounts-daemon.enable = true;
      services.udisks2.enable = true;
      services.upower.enable = true;
      services.geoclue2.enable = true;
      services.telepathy.enable = true;

      services.ayatana-indicators = {
        enable = true;
        packages =
          (
            with pkgs;
            [
              ayatana-indicator-display
              ayatana-indicator-messages
              ayatana-indicator-power
            ]
            ++ lib.optionals config.hardware.bluetooth.enable [ ayatana-indicator-bluetooth ]
            ++ lib.optionals (config.services.pulseaudio.enable || config.services.pipewire.pulse.enable) [
              ayatana-indicator-sound
            ]
          )
          ++ (
            with pkgs.lomiri;
            [ lomiri-telephony-service ]
            ++ lib.optionals config.networking.networkmanager.enable [ lomiri-indicator-network ]
          );
      };

      services.gnome.evolution-data-server = {
        enable = true;
        plugins = [
          # TODO: lomiri.address-book-service
        ];
      };

      services.displayManager = {
        defaultSession = lib.mkDefault "lomiri";
        sessionPackages = with pkgs.lomiri; [ lomiri-session ];
      };

      services.xserver = {
        enable = lib.mkDefault true;
        displayManager.lightdm = {
          enable = lib.mkDefault true;
          greeters.lomiri.enable = lib.mkDefault true;
        };
      };

      environment.pathsToLink = [
        # Configs for inter-app data exchange system
        "/share/lomiri-content-hub/peers"
        # Configs for inter-app URL requests
        "/share/lomiri-url-dispatcher/urls"
        # Splash screens & other images for desktop apps launched via lomiri-app-launch
        "/share/lomiri-app-launch"
        # TODO Try to get maliit stuff working
        "/share/maliit/plugins"
        # At least the network indicator is still under the unity name, due to leftover Unity-isms
        "/share/unity"
        # Data
        "/share/sounds"
      ];

      systemd.user.services =
        let
          lomiriService = "lomiri.service";
          lomiriServiceNames = [
            lomiriService
            "lomiri-full-greeter.service"
            "lomiri-full-shell.service"
            "lomiri-greeter.service"
            "lomiri-shell.service"
          ];
        in
        {
          # Unconditionally run service that collects system-installed URL handlers before LUD
          # TODO also run user-installed one?
          "lomiri-url-dispatcher-update-system-dir" = {
            description = "Lomiri URL dispatcher system directory updater";
            wantedBy = [ "lomiri-url-dispatcher.service" ];
            before = [ "lomiri-url-dispatcher.service" ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${pkgs.lomiri.lomiri-url-dispatcher}/libexec/lomiri-url-dispatcher/lomiri-update-directory /run/current-system/sw/share/lomiri-url-dispatcher/urls/";
            };
          };

          "lomiri-polkit-agent" = {
            description = "Lomiri Polkit agent";
            wantedBy = [ lomiriService ];
            after = [ lomiriService ];
            partOf = [ lomiriService ];
            serviceConfig = {
              Type = "simple";
              Restart = "always";
              ExecStart = "${pkgs.lomiri.lomiri-polkit-agent}/libexec/lomiri-polkit-agent/policykit-agent";
            };
          };

          "mediascanner-2.0" = {
            description = "Media Scanner";
            wantedBy = lomiriServiceNames;
            before = lomiriServiceNames;
            partOf = lomiriServiceNames;
            serviceConfig = {
              Type = "dbus";
              BusName = "com.lomiri.MediaScanner2.Daemon";
              Restart = "on-failure";
              ExecStart = "${lib.getExe pkgs.lomiri.mediascanner2}";
            };
          };
        };

      systemd.services = {
        "dbus-com.lomiri.UserMetrics" = {
          serviceConfig = {
            Type = "dbus";
            BusName = "com.lomiri.UserMetrics";
            User = "usermetrics";
            StandardOutput = "syslog";
            SyslogIdentifier = "com.lomiri.UserMetrics";
            ExecStart = "${pkgs.lomiri.libusermetrics}/libexec/libusermetrics/usermetricsservice";
          }
          // lib.optionalAttrs (!config.security.apparmor.enable) {
            # Due to https://gitlab.com/ubports/development/core/libusermetrics/-/issues/8, auth must be disabled when not using AppArmor, lest the next database usage breaks
            Environment = "USERMETRICS_NO_AUTH=1";
          };
        };
      };

      users.users.usermetrics = {
        group = "usermetrics";
        home = "/var/lib/usermetrics";
        createHome = true;
        isSystemUser = true;
      };

      users.groups.usermetrics = { };
    })
  ];

  meta.maintainers = lib.teams.lomiri.members;
}
