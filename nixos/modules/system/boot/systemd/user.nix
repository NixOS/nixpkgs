{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
with utils;
with systemdUtils.unitOptions;
with lib;

let
  cfg = config.systemd.user;

  systemd = config.systemd.package;

  inherit (systemdUtils.lib)
    makeUnit
    generateUnits
    targetToUnit
    serviceToUnit
    sliceToUnit
    socketToUnit
    timerToUnit
    pathToUnit
    ;

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

  writeTmpfiles =
    {
      rules,
      user ? null,
    }:
    let
      suffix = optionalString (user != null) "-${user}";
    in
    pkgs.writeTextFile {
      name = "nixos-user-tmpfiles.d${suffix}";
      destination = "/etc/xdg/user-tmpfiles.d/00-nixos${suffix}.conf";
      text = ''
        # This file is created automatically and should not be modified.
        # Please change the options ‘systemd.user.tmpfiles’ instead.
        ${concatStringsSep "\n" rules}
      '';
    };
in
{
  options = {
    systemd.user.extraConfig = mkOption {
      default = "";
      type = types.lines;
      example = "DefaultCPUAccounting=yes";
      description = ''
        Extra config options for systemd user instances. See {manpage}`systemd-user.conf(5)` for
        available options.
      '';
    };

    systemd.user.units = mkOption {
      description = "Definition of systemd per-user units.";
      default = { };
      type = systemdUtils.types.units;
    };

    systemd.user.paths = mkOption {
      default = { };
      type = systemdUtils.types.paths;
      description = "Definition of systemd per-user path units.";
    };

    systemd.user.services = mkOption {
      default = { };
      type = systemdUtils.types.services;
      description = "Definition of systemd per-user service units.";
    };

    systemd.user.slices = mkOption {
      default = { };
      type = systemdUtils.types.slices;
      description = "Definition of systemd per-user slice units.";
    };

    systemd.user.sockets = mkOption {
      default = { };
      type = systemdUtils.types.sockets;
      description = "Definition of systemd per-user socket units.";
    };

    systemd.user.targets = mkOption {
      default = { };
      type = systemdUtils.types.targets;
      description = "Definition of systemd per-user target units.";
    };

    systemd.user.timers = mkOption {
      default = { };
      type = systemdUtils.types.timers;
      description = "Definition of systemd per-user timer units.";
    };

    systemd.user.tmpfiles = {
      rules = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "D %C - - - 7d" ];
        description = ''
          Global user rules for creation, deletion and cleaning of volatile and
          temporary files automatically. See
          {manpage}`tmpfiles.d(5)`
          for the exact format.
        '';
      };

      users = mkOption {
        description = ''
          Per-user rules for creation, deletion and cleaning of volatile and
          temporary files automatically.
        '';
        default = { };
        type = types.attrsOf (
          types.submodule {
            options = {
              rules = mkOption {
                type = types.listOf types.str;
                default = [ ];
                example = [ "D %C - - - 7d" ];
                description = ''
                  Per-user rules for creation, deletion and cleaning of volatile and
                  temporary files automatically. See
                  {manpage}`tmpfiles.d(5)`
                  for the exact format.
                '';
              };
            };
          }
        );
      };
    };

    systemd.additionalUpstreamUserUnits = mkOption {
      default = [ ];
      type = types.listOf types.str;
      example = [ ];
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
      "systemd/user".source = generateUnits {
        type = "user";
        inherit (cfg) units;
        upstreamUnits = upstreamUserUnits;
        upstreamWants = [ ];
      };

      "systemd/user.conf".text = ''
        [Manager]
        ${cfg.extraConfig}
      '';
    };

    systemd.user.units =
      mapAttrs' (n: v: nameValuePair "${n}.path" (pathToUnit v)) cfg.paths
      // mapAttrs' (n: v: nameValuePair "${n}.service" (serviceToUnit v)) cfg.services
      // mapAttrs' (n: v: nameValuePair "${n}.slice" (sliceToUnit v)) cfg.slices
      // mapAttrs' (n: v: nameValuePair "${n}.socket" (socketToUnit v)) cfg.sockets
      // mapAttrs' (n: v: nameValuePair "${n}.target" (targetToUnit v)) cfg.targets
      // mapAttrs' (n: v: nameValuePair "${n}.timer" (timerToUnit v)) cfg.timers;

    # Generate timer units for all services that have a ‘startAt’ value.
    systemd.user.timers = mapAttrs (name: service: {
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = service.startAt;
    }) (filterAttrs (name: service: service.startAt != [ ]) cfg.services);

    # Provide the systemd-user PAM service, required to run systemd
    # user instances.
    security.pam.services.systemd-user = {
      # Ensure that pam_systemd gets included. This is special-cased
      # in systemd to provide XDG_RUNTIME_DIR.
      startSession = true;
      # Disable pam_mount in systemd-user to prevent it from being called
      # multiple times during login, because it will prevent pam_mount from
      # unmounting the previously mounted volumes.
      pamMount = false;
    };

    # Some overrides to upstream units.
    systemd.services."user@".restartIfChanged = false;
    systemd.services.systemd-user-sessions.restartIfChanged = false; # Restart kills all active sessions.

    # enable systemd user tmpfiles
    systemd.user.services.systemd-tmpfiles-setup.wantedBy = optional (
      cfg.tmpfiles.rules != [ ] || any (cfg': cfg'.rules != [ ]) (attrValues cfg.tmpfiles.users)
    ) "basic.target";

    # /run/current-system/sw/etc/xdg is in systemd's $XDG_CONFIG_DIRS so we can
    # write the tmpfiles.d rules for everyone there
    environment.systemPackages = optional (cfg.tmpfiles.rules != [ ]) (writeTmpfiles {
      inherit (cfg.tmpfiles) rules;
    });

    # /etc/profiles/per-user/$USER/etc/xdg is in systemd's $XDG_CONFIG_DIRS so
    # we can write a single user's tmpfiles.d rules there
    users.users = mapAttrs (user: cfg': {
      packages = optional (cfg'.rules != [ ]) (writeTmpfiles {
        inherit (cfg') rules;
        inherit user;
      });
    }) cfg.tmpfiles.users;

    system.userActivationScripts.tmpfiles = ''
      ${config.systemd.package}/bin/systemd-tmpfiles --user --create --remove
    '';
  };
}
