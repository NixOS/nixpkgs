{ config, lib, pkgs, ... }:

let
  inherit (lib) mkPackageOption mkEnableOption mkIf mkOption types;
  cfg = config.services.logiops;
  format = pkgs.formats.libconfig { };
in {
  options.services.logiops = {
    enable = mkEnableOption "logiops, an unofficial userspace driver for HID++ Logitech devices";
    package = mkPackageOption pkgs "logiops" {
      example = "logiops_0_2_3";
    };

    settings = mkOption {
      type = types.submodule { freeformType = format.type; };
      description = ''
        Configuration for logiops.

        See <https://github.com/PixlOne/logiops/wiki/Configuration> for more details.
        Also see <https://github.com/PixlOne/logiops/blob/main/logid.example.cfg> for an example config.
      '';
      default = { };
      example = {
        devices = [{
          name = "Wireless Mouse MX Master";
          dpi = 1000;
          buttons = [
            {
              cid = "0xc3";
              action = {
                type = "Gestures";
                gestures = [
                  {
                    direction = "Up";
                    mode = "OnRelease";
                    action = {
                      type = "Keypress";
                      keys = [ "KEY_UP" ];
                    };
                  }
                  {
                    direction = "None";
                    mode = "NoPress";
                  }
                ];
              };
            }
            {
              cid = "0xc4";
              action = {
                type = "Keypress";
                keys = [ "KEY_A" ];
              };
            }
          ];
        }];
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc."logid.cfg".source = format.generate "logid.cfg" cfg.settings;
    systemd.services.logiops = {
      description = "Logitech Configuration Daemon";
      documentation = [ "https://github.com/PixlOne/logiops" ];

      wantedBy = [ "multi-user.target" ];

      startLimitIntervalSec = 0;
      after = [ "multi-user.target" ];
      wants = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/logid";
        Restart = "always";
        User = "root";

        RuntimeDirectory = "logiops";

        CapabilityBoundingSet = [ "CAP_SYS_NICE" ];
        DeviceAllow = [ "/dev/uinput rw" "char-hidraw rw" ];
        ProtectClock = true;
        PrivateNetwork = true;
        ProtectHome = true;
        ProtectHostname = true;
        PrivateUsers = true;
        PrivateMounts = true;
        PrivateTmp = true;
        RestrictNamespaces = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        LockPersonality = true;
        ProtectProc = "invisible";
        SystemCallFilter = [ "nice" "@system-service" "~@privileged" ];
        RestrictAddressFamilies = [ "AF_NETLINK" "AF_UNIX" ];
        RestrictSUIDSGID = true;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProcSubset = "pid";
        UMask = "0077";
      };
    };

    # Add a `udev` rule to restart `logiops` when the mouse is connected
    # https://github.com/PixlOne/logiops/issues/239#issuecomment-1044122412
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="input", ATTRS{id/vendor}=="046d", RUN{program}="${config.systemd.package}/bin/systemctl --no-block try-restart logiops.service"
    '';
  };
}
