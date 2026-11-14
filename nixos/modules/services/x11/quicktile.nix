{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.quicktile;
  format = pkgs.formats.ini { };
  configFile = format.generate "quicktile.cfg" cfg.settings;
in
{
  options.services.quicktile = {
    enable = lib.mkEnableOption "QuickTile, a keyboard-driven window tiling add-on for your existing X11 window manager";

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
      };
      default = { };
      example = {
        general.ModMask = "<Super><Alt>";
        keys.KP_0 = "maximize";
      };
      description = ''
        Settings for QuickTile that should be written to {file}`$XDG_CONFIG_HOME/quicktile.cfg`.

        Recognized keys and their values can be found at <https://ssokolow.com/quicktile/config.html>.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackage = [ pkgs.quicktile ];

    systemd.user.services.quicktile = {
      description = "QuickTile - window tiling add-on for X11 window managers";
      after = [ "graphical-session-pre.target" ];
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      preStart = ''
        install -Dm644 ${configFile} ''${XDG_CONFIG_HOME:-$HOME/.config}/quicktile.cfg
      '';

      script = ''
        ${lib.getExe pkgs.quicktile} --daemonize &
      '';

      restartTriggers = [ configFile ];

      serviceConfig = {
        Type = "forking";
        Restart = "on-failure";

        # Hardening
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectHome = false;
        ProtectSystem = "full"; # strict will block Xlib
        ProcSubset = "pid";

        PrivateTmp = true;
        PrivateNetwork = true;
        PrivateUsers = true;
        PrivateDevices = true;

        RestrictRealtime = true;
        RestrictNamespaces = true;
        RestrictAddressFamilies = [ "AF_UNIX" ];
        RestrictSUIDSGID = true;

        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        IPAddressDeny = "any";
        KeyringMode = "private";
        NoNewPrivileges = true;
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@resources"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
  };
}
