{ config, lib, pkgs, utils, ... }:
with utils;
with systemdUtils.unitOptions;
with lib;

let
  cfg = config.systemd.user;

  systemd = config.systemd.package;

  inherit
    (systemdUtils.lib)
    makeUnit
    generateUnits
    makeJobScript
    unitConfig
    serviceConfig
    commonUnitText
    targetToUnit
    serviceToUnit
    socketToUnit
    timerToUnit
    pathToUnit;

  upstreamUserUnits = [
    "app.slice"
    "background.slice"
    "basic.target"
    "bluetooth.target"
    "default.target"
    "exit.target"
    "graphical-session-pre.target"
    "graphical-session.target"
    "paths.target"
    "printer.target"
    "session.slice"
    "shutdown.target"
    "smartcard.target"
    "sockets.target"
    "sound.target"
    "systemd-exit.service"
    "timers.target"
    "xdg-desktop-autostart.target"
  ] ++ config.systemd.additionalUpstreamUserUnits;
in {
  options = {
    systemd.user.extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "DefaultCPUAccounting=yes";
      description = ''
        Extra config options for systemd user instances. See man systemd-user.conf for
        available options.
      '';
    };

    systemd.user.units = mkOption {
      description = "Definition of systemd per-user units.";
      default = {};
      type = with types; attrsOf (submodule (
        { name, config, ... }:
        { options = concreteUnitOptions;
          config = {
            unit = mkDefault (makeUnit name config);
          };
        }));
    };

    systemd.user.paths = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = pathOptions; } unitConfig ]);
      description = "Definition of systemd per-user path units.";
    };

    systemd.user.services = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = serviceOptions; } unitConfig serviceConfig ] );
      description = "Definition of systemd per-user service units.";
    };

    systemd.user.slices = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = sliceOptions; } unitConfig ] );
      description = "Definition of systemd per-user slice units.";
    };

    systemd.user.sockets = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = socketOptions; } unitConfig ] );
      description = "Definition of systemd per-user socket units.";
    };

    systemd.user.targets = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = targetOptions; } unitConfig] );
      description = "Definition of systemd per-user target units.";
    };

    systemd.user.timers = mkOption {
      default = {};
      type = with types; attrsOf (submodule [ { options = timerOptions; } unitConfig ] );
      description = "Definition of systemd per-user timer units.";
    };

    systemd.additionalUpstreamUserUnits = mkOption {
      default = [];
      type = types.listOf types.str;
      example = [];
      description = ''
        Additional units shipped with systemd that should be enabled for per-user systemd instances.
      '';
      internal = true;
    };
  };

  config = {
    systemd.additionalUpstreamSystemUnits = [
      "user.slice"
    ];

    environment.etc = {
      "systemd/user".source = generateUnits "user" cfg.units upstreamUserUnits [];

      "systemd/user.conf".text = ''
        [Manager]
        ${cfg.extraConfig}
      '';
    };

    systemd.user.units =
         mapAttrs' (n: v: nameValuePair "${n}.path"    (pathToUnit    n v)) cfg.paths
      // mapAttrs' (n: v: nameValuePair "${n}.service" (serviceToUnit n v)) cfg.services
      // mapAttrs' (n: v: nameValuePair "${n}.slice"   (sliceToUnit   n v)) cfg.slices
      // mapAttrs' (n: v: nameValuePair "${n}.socket"  (socketToUnit  n v)) cfg.sockets
      // mapAttrs' (n: v: nameValuePair "${n}.target"  (targetToUnit  n v)) cfg.targets
      // mapAttrs' (n: v: nameValuePair "${n}.timer"   (timerToUnit   n v)) cfg.timers;

    # Generate timer units for all services that have a ‘startAt’ value.
    systemd.user.timers =
      mapAttrs (name: service: {
        wantedBy = ["timers.target"];
        timerConfig.OnCalendar = service.startAt;
      })
      (filterAttrs (name: service: service.startAt != []) cfg.services);

    # Provide the systemd-user PAM service, required to run systemd
    # user instances.
    security.pam.services.systemd-user =
      { # Ensure that pam_systemd gets included. This is special-cased
        # in systemd to provide XDG_RUNTIME_DIR.
        startSession = true;
      };

    # Some overrides to upstream units.
    systemd.services."user@".restartIfChanged = false;
    systemd.services.systemd-user-sessions.restartIfChanged = false; # Restart kills all active sessions.
  };
}
