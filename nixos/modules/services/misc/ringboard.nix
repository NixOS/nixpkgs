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
    x11Package = lib.mkPackageOption pkgs "ringboard" { };
    waylandPackage = lib.mkPackageOption pkgs "ringboard-wayland" { };
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
        ExecStart = "${if cfg.x11.enable then cfg.x11Package else cfg.waylandPackage}/bin/ringboard-server";
        Restart = "on-failure";
        Slice = "session-ringboard.slice";
      };
    };

    systemd.user.services.ringboard-x11 = lib.mkIf cfg.x11.enable {
      description = "Ringboard clipboard listener (X11)";
      documentation = [ "https://github.com/SUPERCILEX/clipboard-history" ];
      requires = [ "ringboard-server.service" ];
      after = [
        "ringboard-server.service"
        "graphical-session.target"
      ];
      bindsTo = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${cfg.x11Package}/bin/ringboard-x11";
        Restart = "on-failure";
        Slice = "session-ringboard.slice";
      };
      environment.RUST_LOG = "trace";
    };

    systemd.user.services.ringboard-wayland = lib.mkIf cfg.wayland.enable {
      description = "Ringboard clipboard listener (Wayland)";
      documentation = [ "https://github.com/SUPERCILEX/clipboard-history" ];
      requires = [ "ringboard-server.service" ];
      after = [
        "ringboard-server.service"
        "graphical-session.target"
      ];
      bindsTo = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${cfg.waylandPackage}/bin/ringboard-wayland";
        Restart = "on-failure";
        Slice = "session-ringboard.slice";
      };
      environment.RUST_LOG = "trace";
    };

    systemd.user.slices.session-ringboard = {
      description = "Ringboard clipboard services";
    };

    environment.systemPackages =
      lib.optionals cfg.x11.enable [ cfg.x11Package ]
      ++ lib.optionals cfg.wayland.enable [ cfg.waylandPackage ];
  };
}
