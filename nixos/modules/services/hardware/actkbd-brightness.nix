{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.actkbd.brightness;

  inherit (lib)
    concatStringsSep
    getExe
    mkEnableOption
    mkOption
    singleton
    types
    ;

  actkbdConfig = pkgs.writeText "actkbd-brightness.conf" ''
    224:key,rep:exec:${cfg.upCommand}
    225:key,rep:exec:${cfg.downCommand}
  '';
in
{
  options.services.actkbd.brightness = {
    enable = mkEnableOption ''
      a hardened systemd unit to for global brightness control hotkeys with actkbd.
      This hardening is specifically tailored to only allow the controlling of brightness, to minimize the attack surface, since actkbd is a service that runs run arbitrary (configured) commands.
      So far it has only been tested on one system, so if it doesn't work for you, please open an issue.
    '';
    upCommand = mkOption {
      type = types.str;
      description = ''
        Command to increase the brightness.
        Use the full path, to the binary in the store since the unit won't have access to PATH.
      '';
      default = "${getExe pkgs.brightnessctl} set +5%";
    };
    downCommand = lib.mkOption {
      type = types.str;
      description = ''
        Command to increase the brightness.
        Use the full path, to the binary in the store since the unit won't have access to PATH.
      '';
      default = "${getExe pkgs.brightnessctl} set 5%-";
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = singleton (
      pkgs.writeTextFile {
        name = "actkbd-brightness-udev-rules";
        destination = "/etc/udev/rules.d/61-actkbd-brightness.rules";
        text = concatStringsSep ", " [
          ''ACTION=="add"''
          ''KERNEL=="event[0-9]*"''
          ''SUBSYSTEM=="input"''
          ''ENV{ID_INPUT_KEY}=="1"''
          ''ENV{ID_PATH}=="acpi-LNXVIDEO:[0-9]*"''
          ''TAG+="systemd"''
          ''ENV{SYSTEMD_WANTS}+="actkbd-brightness@$env{DEVNAME}.service"''
        ];
      }
    );

    systemd.services."actkbd-brightness@" = {
      restartIfChanged = true;
      unitConfig = {
        Description = "actkbd on %I for brightness control";
        ConditionPathExists = "%I";
      };

      serviceConfig = {
        Type = "forking";
        ExecStart = "${lib.getExe pkgs.actkbd} -D -c ${actkbdConfig} -d %I";

        # hardening

        # allow access to event device
        DeviceAllow = [ "%I" ];
        DevicePolicy = "closed";

        CapabilityBoundingSet = "";
        IPAddressDeny = "any";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = "none";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SocketBindDeny = "any";
        SystemCallArchitectures = "native";
        SystemCallFilter = "~@aio:EPERM @chown:EPERM @clock:EPERM @cpu-emulation:EPERM @debug:EPERM @io-event:EPERM @keyring:EPERM @memlock:EPERM @module:EPERM @mount:EPERM @network-io:EPERM @obsolete:EPERM @pkey:EPERM @privileged:EPERM @raw-io:EPERM @reboot:EPERM @resources:EPERM @sandbox:EPERM @setuid:EPERM @swap:EPERM @sync:EPERM @timer:EPERM";
        UMask = "0077";

        # -> 1.2 OK
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ quantenzitrone ];
}
