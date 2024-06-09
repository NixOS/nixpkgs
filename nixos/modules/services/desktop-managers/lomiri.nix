{ config, pkgs, lib, ... }:

let
  cfg = config.services.desktopManager.lomiri;
in {
  options.services.desktopManager.lomiri = {
    enable = lib.mkEnableOption ''
      the Lomiri graphical shell (formerly known as Unity8)
    '';
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = (with pkgs; [
        glib # XDG MIME-related tools identify it as GNOME, add gio for MIME identification to work
        libayatana-common
        ubports-click
      ]) ++ (with pkgs.lomiri; [
        content-hub
        hfd-service
        history-service
        libusermetrics
        lomiri
        lomiri-download-manager
        lomiri-filemanager-app
        lomiri-schemas # exposes some required dbus interfaces
        lomiri-session # wrappers to properly launch the session
        lomiri-sounds
        lomiri-system-settings
        lomiri-terminal-app
        lomiri-thumbnailer
        lomiri-url-dispatcher
        lomiri-wallpapers
        mediascanner2 # TODO possibly needs to be kicked off by graphical-session.target
        morph-browser
        qtmir # not having its desktop file for Xwayland available causes any X11 application to crash the session
        suru-icon-theme
        # telephony-service # currently broken: https://github.com/NixOS/nixpkgs/pull/314043
      ]);
      variables = {
        # To override the keyboard layouts in Lomiri
        NIXOS_XKB_LAYOUTS = config.services.xserver.xkb.layout;
      };
    };

    hardware.pulseaudio.enable = lib.mkDefault true;
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

    fonts.packages = with pkgs; [
      # Applications tend to default to Ubuntu font
      ubuntu_font_family
    ];

    # Copy-pasted basic stuff
    hardware.opengl.enable = lib.mkDefault true;
    fonts.enableDefaultPackages = lib.mkDefault true;
    programs.dconf.enable = lib.mkDefault true;

    # Xwayland is partly hardcoded in Mir so it can't really be fully turned off, and it must be on PATH for X11 apps *and Lomiri's web browser* to work.
    # Until Mir/Lomiri can be properly used without it, force it on so everything behaves as expected.
    programs.xwayland.enable = lib.mkForce true;

    services.accounts-daemon.enable = true;

    services.ayatana-indicators = {
      enable = true;
      packages = (with pkgs; [
        ayatana-indicator-datetime
        ayatana-indicator-display
        ayatana-indicator-messages
        ayatana-indicator-power
        ayatana-indicator-session
      ] ++ lib.optionals (config.hardware.pulseaudio.enable || config.services.pipewire.pulse.enable) [
        ayatana-indicator-sound
      ]) ++ (with pkgs.lomiri; [
        # telephony-service # currently broken: https://github.com/NixOS/nixpkgs/pull/314043
      ] ++ lib.optionals config.networking.networkmanager.enable [
        lomiri-indicator-network
      ]);
    };

    services.udisks2.enable = true;
    services.upower.enable = true;
    services.geoclue2.enable = true;

    services.gnome.evolution-data-server = {
      enable = true;
      plugins = with pkgs; [
        # TODO: lomiri.address-book-service
      ];
    };

    services.telepathy.enable = true;

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
      "/share/content-hub/peers"
      # Configs for inter-app URL requests
      "/share/lomiri-url-dispatcher/urls"
      # Splash screens & other images for desktop apps launched via lomiri-app-launch
      "/share/lomiri-app-launch"
      # TODO Try to get maliit stuff working
      "/share/maliit/plugins"
      # At least the network indicator is still under the unity name, due to leftover Unity-isms
      "/share/unity"
      # Data
      "/share/locale" # TODO LUITK hardcoded default locale path, fix individual apps to not rely on it
      "/share/sounds"
      "/share/wallpapers"
    ];

    systemd.user.services = {
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
        } // lib.optionalAttrs (!config.security.apparmor.enable) {
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

    # TODO content-hub cannot pass files between applications without asking AA for permissions. And alot of the Lomiri stack is designed with AA availability in mind. This might be a requirement to be closer to upstream?
    # But content-hub currently fails to pass files between applications even with AA enabled, and we can get away without AA in many places. Let's see how this develops before requiring this for good.
    # security.apparmor.enable = true;
  };

  meta.maintainers = lib.teams.lomiri.members;
}
