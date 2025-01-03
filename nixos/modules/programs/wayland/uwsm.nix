{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.uwsm;

  # Helper function to create desktop entry files for UWSM-managed compositors
  mk_uwsm_desktop_entry =
    opts:
    (pkgs.writeTextFile {
      name = "${opts.name}-uwsm";
      text = ''
        [Desktop Entry]
        Name=${opts.prettyName} (UWSM)
        Comment=${opts.comment}
        Exec=${lib.getExe cfg.package} start -S -F ${opts.binPath}
        Type=Application
      '';
      destination = "/share/wayland-sessions/${opts.name}-uwsm.desktop";
      derivationArgs = {
        passthru.providedSessions = [ "${opts.name}-uwsm" ];
      };
    });
in
{
  options.programs.uwsm = {
    enable = lib.mkEnableOption ''
      uwsm, which wraps standalone Wayland compositors with a set
      of Systemd units on the fly. This essentially
      binds the wayland compositor into `graphical-session-pre.target`,
      `graphical-session.target`, `xdg-desktop-autostart.target`.

      This is useful for Wayland compositors like Hyprland, Sway, Wayfire,
      etc. that do not start these targets and services on their own.

      ::: {.note}
      You must configure `waylandCompositors` suboptions as well
      so that UWSM knows which compositors to manage.

      Additionally, this by default uses `dbus-broker` as the dbus
      implementation for better compatibility. If you dislike this behavior
      you can set `services.dbus.implementation = lib.mkForce "dbus"`
      in your configuration.
      :::

      If you are having trouble starting a service that depends on
      `graphical-session.target`, while using a WM, enabling this option
      might help
    '';
    package = lib.mkPackageOption pkgs "uwsm" { };

    waylandCompositors = lib.mkOption {
      description = ''
        Configuration for UWSM-managed Wayland Compositors. This
        creates a desktop entry file which will be used by Display
        Managers like GDM, to allow starting the UWSM managed session.
      '';
      type = lib.types.attrsOf (
        lib.types.submodule (
          { ... }:
          {
            options = {
              prettyName = lib.mkOption {
                type = lib.types.str;
                description = "The full name of the desktop entry file.";
                example = "ExampleWaylandCompositor";
              };
              comment = lib.mkOption {
                type = lib.types.str;
                description = "The comment field of the desktop entry file.";
                default = "An intelligent Wayland compositor managed by UWSM.";
              };
              binPath = lib.mkOption {
                type = lib.types.path;
                description = ''
                  The wayland-compositor binary path that will be called by UWSM.

                  It is recommended to use the `/run/current-system/sw/bin/` path
                  instead of `lib.getExe pkgs.<compositor>` to avoid version mismatch
                  of the compositor used by UWSM and the one installed in the system.
                '';
                example = "/run/current-system/sw/bin/ExampleCompositor";
              };
            };
          }
        )
      );
      example = lib.literalExpression ''
        hyprland = {
          prettyName = "Hyprland";
          comment = "Hyprland compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/Hyprland";
        };
        sway = {
          prettyName = "Sway";
          comment = "Sway compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/sway";
        };
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
    environment.pathsToLink = [ "/share/uwsm" ];

    services.graphical-desktop.enable = true;

    # UWSM recommends dbus broker for better compatibility
    services.dbus.implementation = "broker";

    services.displayManager.sessionPackages = lib.mapAttrsToList (
      name: value:
      mk_uwsm_desktop_entry {
        inherit name;
        inherit (value) prettyName comment binPath;
      }
    ) cfg.waylandCompositors;
  };

  meta.maintainers = with lib.maintainers; [
    johnrtitor
    kai-tub
  ];
}
