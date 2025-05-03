{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.dwl;
in
{
  options.programs.dwl = {
    enable = lib.mkEnableOption ''
      Dwl is a compact, hackable compositor for Wayland based on wlroots.
      You can manually launch Dwl by executing "exec dwl" on a TTY.
    '';

    package = lib.mkPackageOption pkgs "dwl" {
      example = ''
        pkgs.dwl.overrideAttrs (oldAttrs: rec {
          buildInputs =
            oldAttrs.buildInputs
            ++ [
              pkgs.libdrm
              pkgs.fcft
            ];
          patches = [
            ./dwl-patches/bar-patch.patch
          ];
        })
      '';
    };

    extraSessionCommands = lib.mkOption {
      default = "";
      type = lib.types.lines;
      description = ''
        Shell commands executed just before dwl is started.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Create systemd target for dwl session
    systemd.user.targets.dwl-session = {
      description = "dwl compositor session";
      documentation = [ "man:systemd.special(7)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    # Create wrapper script for dwl
    environment.etc."xdg/dwl-session" = {
      text = ''
        #!/bin/sh

        # Import environment variables
        ${cfg.extraSessionCommands}

        # Setup systemd user environment
        systemctl --user import-environment DISPLAY WAYLAND_DISPLAY
        systemctl --user start dwl-session.target

        # Start dwl
        exec ${cfg.package}/bin/dwl
      '';
      mode = "0755"; # Make it executable
    };

    # Create desktop entry for display managers
    services.displayManager.sessionPackages =
      let
        dwlDesktopFile = pkgs.writeTextFile {
          name = "dwl-desktop-entry";
          destination = "/share/wayland-sessions/dwl.desktop";
          text = ''
            [Desktop Entry]
            Name=dwl
            Comment=Dynamic window manager for Wayland
            Exec=/etc/xdg/dwl-session
            Type=Application
          '';
        };

        dwlSession = pkgs.symlinkJoin {
          name = "dwl-session";
          paths = [ dwlDesktopFile ];
          passthru.providedSessions = [ "dwl" ];
        };
      in
      [ dwlSession ];

    # Configure XDG portal for dwl (minimal configuration)
    xdg.portal.config.dwl.default = lib.mkDefault [
      "wlr"
      "gtk"
    ];
  };
}
