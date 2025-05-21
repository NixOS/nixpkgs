{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.xserver.desktopManager.phosh;

  # Based on https://source.puri.sm/Librem5/librem5-base/-/blob/4596c1056dd75ac7f043aede07887990fd46f572/default/sm.puri.OSK0.desktop
  oskItem = pkgs.makeDesktopItem {
    name = "sm.puri.OSK0";
    desktopName = "On-screen keyboard";
    exec = "${pkgs.squeekboard}/bin/squeekboard";
    categories = [
      "GNOME"
      "Core"
    ];
    onlyShowIn = [ "GNOME" ];
    noDisplay = true;
    extraConfig = {
      X-GNOME-Autostart-Phase = "Panel";
      X-GNOME-Provides = "inputmethod";
      X-GNOME-Autostart-Notify = "true";
      X-GNOME-AutoRestart = "true";
    };
  };

  phocConfigType = lib.types.submodule {
    options = {
      xwayland = lib.mkOption {
        description = ''
          Whether to enable XWayland support.

          To start XWayland immediately, use `immediate`.
        '';
        type = lib.types.enum [
          "true"
          "false"
          "immediate"
        ];
        default = "false";
      };
      cursorTheme = lib.mkOption {
        description = ''
          Cursor theme to use in Phosh.
        '';
        type = lib.types.str;
        default = "default";
      };
      outputs = lib.mkOption {
        description = ''
          Output configurations.
        '';
        type = lib.types.attrsOf phocOutputType;
        default = {
          DSI-1 = {
            scale = 2;
          };
        };
      };
    };
  };

  phocOutputType = lib.types.submodule {
    options = {
      modeline = lib.mkOption {
        description = ''
          One or more modelines.
        '';
        type = lib.types.either lib.types.str (lib.types.listOf lib.types.str);
        default = [ ];
        example = [
          "87.25 720 776 848  976 1440 1443 1453 1493 -hsync +vsync"
          "65.13 768 816 896 1024 1024 1025 1028 1060 -HSync +VSync"
        ];
      };
      mode = lib.mkOption {
        description = ''
          Default video mode.
        '';
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "768x1024";
      };
      scale = lib.mkOption {
        description = ''
          Display scaling factor.
        '';
        type =
          lib.types.nullOr (lib.types.addCheck (lib.types.either lib.types.int lib.types.float) (x: x > 0))
          // {
            description = "null or positive integer or float";
          };
        default = null;
        example = 2;
      };
      rotate = lib.mkOption {
        description = ''
          Screen transformation.
        '';
        type = lib.types.enum [
          "90"
          "180"
          "270"
          "flipped"
          "flipped-90"
          "flipped-180"
          "flipped-270"
          null
        ];
        default = null;
      };
    };
  };

  optionalKV = k: v: lib.optionalString (v != null) "${k} = ${builtins.toString v}";

  renderPhocOutput =
    name: output:
    let
      modelines = if builtins.isList output.modeline then output.modeline else [ output.modeline ];
      renderModeline = l: "modeline = ${l}";
    in
    ''
      [output:${name}]
      ${lib.concatStringsSep "\n" (map renderModeline modelines)}
      ${optionalKV "mode" output.mode}
      ${optionalKV "scale" output.scale}
      ${optionalKV "rotate" output.rotate}
    '';

  renderPhocConfig =
    phoc:
    let
      outputs = lib.mapAttrsToList renderPhocOutput phoc.outputs;
    in
    ''
      [core]
      xwayland = ${phoc.xwayland}
      ${lib.concatStringsSep "\n" outputs}
      [cursor]
      theme = ${phoc.cursorTheme}
    '';
in

{
  options = {
    services.xserver.desktopManager.phosh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Phone Shell.";
      };

      package = lib.mkPackageOption pkgs "phosh" { };

      user = lib.mkOption {
        description = "The user to run the Phosh service.";
        type = lib.types.str;
        example = "alice";
      };

      group = lib.mkOption {
        description = "The group to run the Phosh service.";
        type = lib.types.str;
        example = "users";
      };

      phocConfig = lib.mkOption {
        description = ''
          Configurations for the Phoc compositor.
        '';
        type = lib.types.oneOf [
          lib.types.lines
          lib.types.path
          phocConfigType
        ];
        default = { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Inspired by https://gitlab.gnome.org/World/Phosh/phosh/-/blob/main/data/phosh.service
    systemd.services.phosh = {
      wantedBy = [ "graphical.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/phosh-session";
        User = cfg.user;
        Group = cfg.group;
        PAMName = "login";
        WorkingDirectory = "~";
        Restart = "always";

        TTYPath = "/dev/tty7";
        TTYReset = "yes";
        TTYVHangup = "yes";
        TTYVTDisallocate = "yes";

        # Fail to start if not controlling the tty.
        StandardInput = "tty-fail";
        StandardOutput = "journal";
        StandardError = "journal";

        # Log this user with utmp, letting it show up with commands 'w' and 'who'.
        UtmpIdentifier = "tty7";
        UtmpMode = "user";
      };
      environment = {
        # We are running without a display manager, so need to provide
        # a value for XDG_CURRENT_DESKTOP.
        #
        # Among other things, this variable influences:
        #  - visibility of desktop entries with "OnlyShowIn=Phosh;"
        #    https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-1.5.html#key-onlyshowin
        #  - the chosen xdg-desktop-portal configuration.
        #    https://flatpak.github.io/xdg-desktop-portal/docs/portals.conf.html
        XDG_CURRENT_DESKTOP = "Phosh:GNOME";
        # pam_systemd uses these to identify the session in logind.
        # https://www.freedesktop.org/software/systemd/man/latest/pam_systemd.html#desktop=
        XDG_SESSION_DESKTOP = "phosh";
        XDG_SESSION_TYPE = "wayland";
      };
    };

    environment.systemPackages = [
      pkgs.phoc
      cfg.package
      pkgs.squeekboard
      oskItem
    ];

    systemd.packages = [ cfg.package ];

    programs.feedbackd.enable = true;

    security.pam.services.phosh = { };

    services.graphical-desktop.enable = true;

    services.gnome.core-shell.enable = true;
    services.gnome.core-os-services.enable = true;
    services.displayManager.sessionPackages = [ cfg.package ];

    environment.etc."phosh/phoc.ini".source =
      if builtins.isPath cfg.phocConfig then
        cfg.phocConfig
      else if builtins.isString cfg.phocConfig then
        pkgs.writeText "phoc.ini" cfg.phocConfig
      else
        pkgs.writeText "phoc.ini" (renderPhocConfig cfg.phocConfig);
  };
}
