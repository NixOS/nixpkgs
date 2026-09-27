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
        # Lets apply bar patch from:
        # https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/bar
        (pkgs.dwl.override {
          configH = ./dwl-config.h;
        }).overrideAttrs (oldAttrs: {
          buildInputs =
            oldAttrs.buildInputs or []
            ++ [
              pkgs.libdrm
              pkgs.fcft
            ];
          patches = oldAttrs.patches or [] ++ [
            ./bar-0.7.patch
          ];
        });
      '';
    };

    extraSessionCommands = lib.mkOption {
      example = ''
        foot --server &
      '';
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
        #!${pkgs.runtimeShell}
        set -euo pipefail

        # Set session info
        export XDG_SESSION_TYPE=wayland
        export XDG_CURRENT_DESKTOP=dwl

        # Path to compositor and socket
        DWL_BIN="${lib.getExe cfg.package}"
        WAYLAND_SOCKET_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
        WAYLAND_SOCKET_PATH="$WAYLAND_SOCKET_DIR/wayland-0"

        # Start dwl in background
        "$DWL_BIN" &
        DWL_PID=$!

        # Wait for dwl to create the Wayland socket
        echo "Waiting for dwl to initialize..."
        for _ in $(seq 1 50); do
            if [ -S "$WAYLAND_SOCKET_PATH" ]; then
                echo "dwl socket detected: $WAYLAND_SOCKET_PATH"
                break
            fi
            sleep 0.1
        done

        # Export and import environment
        systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP
        systemctl --user start dwl-session.target

        # Launch extraSessionCommands
        ${cfg.extraSessionCommands}

        # Wait for dwl to exit (cleans up properly)
        wait "$DWL_PID"
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

  meta.maintainers = with lib.maintainers; [ gurjaka ];
}
