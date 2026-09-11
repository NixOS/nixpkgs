{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.tetrd;
  useResolvconf = config.networking.resolvconf.enable;

  runtimeDir = "/run/tetrd";
  # Outside the chroot: RootDirectory is read-only, so DNS must live here.
  resolvDir = "/run/tetrd-dns";
  privateResolv = "${resolvDir}/resolv.conf";
  # GUI runs outside the chroot and expects this path.
  privateResolvState = "${runtimeDir}/resolv.conf.state";

  resolvconfBin = "${config.networking.resolvconf.package}/bin/resolvconf";
  systemctl = "${config.systemd.package}/bin/systemctl";

  ensureChrootTree = pkgs.writeShellScript "tetrd-ensure-chroot-tree" ''
    set -euo pipefail
    rd=${runtimeDir}
    rvd=${resolvDir}
    mkdir -p "$rd/run" "$rd/etc" "$rvd"

    # Create only if missing. chmod/chown on every run re-fires path units.
    ensure() {
      local f=$1 init=$2 ref=$3 mode=$4
      [[ -e $f ]] && return 0
      if [[ -n $init ]]; then
        printf '%s' "$init" >"$f"
      else
        : >"$f"
      fi
      [[ -d $ref ]] && chown --reference="$ref" "$f" 2>/dev/null || true
      chmod "$mode" "$f" 2>/dev/null || true
    }

    ensure ${privateResolv} "" "$rvd" 660
    # Empty mountpoint for BindPaths privateResolv → chroot /etc/resolv.conf.
    ensure "$rd/etc/resolv.conf" "" "$rd" 660
    ensure ${privateResolvState} "{}" "$rd" 644
    chown --reference="$rd" "$rd/run" "$rd/etc" 2>/dev/null || true
  '';

  applyDns = pkgs.writeShellScript "tetrd-apply-dns" ''
    set -euo pipefail
    f=${privateResolv}
    if [[ -s $f ]] && grep -qE '^[[:space:]]*nameserver[[:space:]]+' "$f"; then
      ${resolvconfBin} -a tetrd -m 0 <"$f"
    else
      ${resolvconfBin} -d tetrd 2>/dev/null || true
    fi
    [[ -e /etc/resolv.conf ]] || ${resolvconfBin} -u
  '';

  removeDns = pkgs.writeShellScript "tetrd-remove-dns" ''
    set -euo pipefail
    ${resolvconfBin} -d tetrd 2>/dev/null || true
  '';

  ensureHostResolv = pkgs.writeShellScript "tetrd-ensure-host-resolv" ''
    set -euo pipefail
    [[ -e /etc/resolv.conf ]] || ${resolvconfBin} -u
  '';

  helperSandbox = {
    PrivateTmp = true;
    ProtectHome = true;
    SystemCallArchitectures = "native";
  };

  oneshot = extra: {
    startLimitIntervalSec = 0;
    serviceConfig =
      helperSandbox
      // {
        Type = "oneshot";
      }
      // extra;
  };

  # partOf alone for the debounce timer: requiredBy + RemainAfterElapse=false
  # would stop tetrd when the timer finishes.
  partOfTetrd = {
    partOf = [ "tetrd.service" ];
  };
  pathTiedToTetrd = partOfTetrd // {
    requiredBy = [ "tetrd.service" ];
  };
in
{
  options.services.tetrd = {
    # mkEnableOption string only — do not touch pkgs.tetrd (unfree) at eval.
    enable = lib.mkEnableOption "USB tethering and reverse-tethering";
    package = lib.mkPackageOption pkgs "tetrd" { };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [ cfg.package ];

        users.groups.tetrd-usb = { };

        # Daemon needs the group; uaccess keeps desktop seats on USB (adb, etc.).
        services.udev.extraRules = ''
          SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", MODE="0660", GROUP="tetrd-usb", TAG+="uaccess"
        '';

        security.wrappers.tetrd-lnsock = {
          source = "${cfg.package}/opt/Tetrd/bin/lnsock";
          owner = "root";
          group = "root";
          capabilities = "cap_dac_override+ep";
        };

        systemd = {
          services = {
            tetrd-chroot-tree = {
              description = "Ensure tetrd runtime directories and files";
              before = [ "tetrd.service" ];
              requiredBy = [ "tetrd.service" ];
            }
            // oneshot {
              ExecStart = ensureChrootTree;
              PrivateNetwork = true;
            };

            tetrd = {
              description = cfg.package.meta.description;
              wantedBy = [ "multi-user.target" ];
              after = [
                "dbus.service"
                "network.target"
                "tetrd-chroot-tree.service"
              ];
              requires = [ "tetrd-chroot-tree.service" ];

              serviceConfig = {
                ExecStartPre = "+${ensureChrootTree}";
                ExecStart = "${cfg.package}/bin/tetrd-service";
                Restart = "always";
                RestartSec = "2s";

                RuntimeDirectory = [
                  "tetrd"
                  "tetrd-dns"
                ];
                # GUI (not DynamicUser) must traverse here for resolv.conf.state.
                RuntimeDirectoryMode = "0755";
                RootDirectory = runtimeDir;
                StateDirectory = "Tetrd";
                StateDirectoryMode = "0700";
                LogsDirectory = "Tetrd";
                LogsDirectoryMode = "0750";

                DynamicUser = true;
                SupplementaryGroups = [ "tetrd-usb" ];
                UMask = "0077";

                CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
                AmbientCapabilities = [ "CAP_NET_ADMIN" ];

                # USB device nodes + TUN (tetrd0). Use char-usb_device, not bare usb_device.
                DevicePolicy = "closed";
                DeviceAllow = [
                  "char-usb_device rwm"
                  "/dev/net/tun rw"
                ];

                LockPersonality = true;
                MemoryDenyWriteExecute = true;
                NoNewPrivileges = true;
                PrivateIPC = true;
                PrivateMounts = true;
                PrivateNetwork = lib.mkDefault false;
                PrivateTmp = true;
                PrivateUsers = lib.mkDefault false;
                ProtectClock = true;
                ProtectControlGroups = true;
                ProtectHome = true;
                ProtectHostname = true;
                ProtectKernelLogs = true;
                ProtectKernelModules = true;
                ProtectKernelTunables = true;
                ProtectProc = "invisible";
                # ProcSubset=pid hides /proc/net and breaks phone connect.
                ProtectSystem = "strict";
                RemoveIPC = true;
                RestrictNamespaces = true;
                RestrictRealtime = true;
                RestrictSUIDSGID = true;
                SystemCallArchitectures = "native";
                SystemCallErrorNumber = "EPERM";
                KeyringMode = "private";

                RestrictAddressFamilies = [
                  "AF_UNIX"
                  "AF_INET"
                  "AF_INET6"
                  "AF_NETLINK"
                ];

                SystemCallFilter = [
                  "@system-service"
                  "~@aio"
                  "~@chown"
                  "~@clock"
                  "~@cpu-emulation"
                  "~@debug"
                  "~@keyring"
                  "~@memlock"
                  "~@module"
                  "~@mount"
                  "~@obsolete"
                  "~@pkey"
                  "~@raw-io"
                  "~@reboot"
                  "~@swap"
                  "~@sync"
                ];

                BindReadOnlyPaths = [
                  builtins.storeDir
                  "/etc/ssl"
                  "/etc/static/ssl"
                  "${pkgs.net-tools}/bin/route:/usr/bin/route"
                  "${pkgs.net-tools}/bin/ifconfig:/usr/bin/ifconfig"
                  "${pkgs.dbus}/bin/dbus-launch:/usr/bin/dbus-launch"
                ];

                BindPaths = [
                  "${privateResolv}:/etc/resolv.conf"
                  "${runtimeDir}/run:/run"
                  # Whole /run/dbus is not a directory tree on NixOS — socket only.
                  "/run/dbus/system_bus_socket:/run/dbus/system_bus_socket"
                ];
              };
            };
          };

          # Seeded-file parents only. Watching run/ thrashes on socket traffic.
          paths.tetrd-chroot-tree = pathTiedToTetrd // {
            pathConfig = {
              PathChanged = [
                runtimeDir
                "${runtimeDir}/etc"
                resolvDir
              ];
              Unit = "tetrd-chroot-tree.service";
            };
          };
        };
      }

      (lib.mkIf useResolvconf {
        systemd = {
          services = {
            tetrd-dns-apply = {
              description = "Push tetrd DNS into resolvconf";
            }
            // oneshot { ExecStart = applyDns; };

            # Restart the timer so each resolv write resets the 300ms debounce.
            tetrd-dns-arm = {
              description = "Schedule tetrd DNS apply";
            }
            // oneshot {
              ExecStart = "${systemctl} restart tetrd-dns-apply.timer";
              PrivateNetwork = true;
              RestrictAddressFamilies = [ "AF_UNIX" ];
            };

            tetrd-dns = {
              description = "tetrd resolvconf lifecycle";
              after = [ "tetrd.service" ];
              bindsTo = [ "tetrd.service" ];
              wantedBy = [ "tetrd.service" ];
            }
            // oneshot {
              RemainAfterExit = true;
              ExecStart = ensureHostResolv;
              ExecStop = removeDns;
            };
          };

          timers.tetrd-dns-apply = partOfTetrd // {
            timerConfig = {
              OnActiveSec = "300ms";
              AccuracySec = "100ms";
              RemainAfterElapse = false;
            };
          };

          # Watch the directory: a file watch dies if resolv.conf is deleted.
          paths.tetrd-dns = pathTiedToTetrd // {
            pathConfig = {
              PathModified = resolvDir;
              Unit = "tetrd-dns-arm.service";
            };
          };
        };
      })
    ]
  );
}
