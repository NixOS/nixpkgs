{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ringboard;
in
{
  options.services.ringboard = {
    x11.enable = lib.mkEnableOption "X11 support for Ringboard";
    wayland.enable = lib.mkEnableOption "Wayland support for Ringboard";
    x11.package = lib.mkPackageOption pkgs "ringboard" { };
    wayland.package = lib.mkPackageOption pkgs "ringboard-wayland" { };
  };

  config = lib.mkIf (cfg.x11.enable || cfg.wayland.enable) {
    systemd.user.services.ringboard-server = {
      description = "Ringboard server";
      documentation = [ "https://github.com/SUPERCILEX/clipboard-history" ];
      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "notify";
        Environment = "RUST_LOG=trace";
        ExecStart = "${
          if cfg.x11.enable then cfg.x11.package else cfg.wayland.package
        }/bin/ringboard-server";
        Restart = "on-failure";
        Slice = "session-ringboard.slice";
      };
    };

    systemd.user.services.ringboard-listener = {
      description = "Ringboard clipboard listener";
      documentation = [ "https://github.com/SUPERCILEX/clipboard-history" ];
      requires = [ "ringboard-server.service" ];
      after = [
        "ringboard-server.service"
        "graphical-session.target"
      ];
      bindsTo = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      script =
        if cfg.x11.enable && cfg.wayland.enable then
          ''
            if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
              exec '${cfg.wayland.package}'/bin/ringboard-wayland
            else
              exec '${cfg.x11.package}'/bin/ringboard-x11
            fi
          ''
        else if cfg.wayland.enable then
          ''
            exec '${cfg.wayland.package}'/bin/ringboard-wayland
          ''
        else
          ''
            exec '${cfg.x11.package}'/bin/ringboard-x11
          '';
      serviceConfig = {
        Type = "exec";
        Restart = "on-failure";
        Slice = "session-ringboard.slice";
      };
      environment.RUST_LOG = "trace";
    };

    systemd.user.slices.session-ringboard = {
      description = "Ringboard clipboard services";
    };

    environment.systemPackages =
      lib.optionals cfg.x11.enable [ cfg.x11.package ]
      ++ lib.optionals cfg.wayland.enable [ cfg.wayland.package ];
  };
}
