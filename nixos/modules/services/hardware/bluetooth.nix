{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.hardware.bluetooth;
  package = cfg.package;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    mkRenamedOptionModule
    mkRemovedOptionModule
    concatStringsSep
    optional
    optionalAttrs
    recursiveUpdate
    types
    ;

  persistPowerState = cfg.powerOnBoot == "auto";

  cfgFmt = pkgs.formats.ini { };

  defaults = {
    General.ControllerMode = "dual";
    Policy.AutoEnable = if persistPowerState then true else cfg.powerOnBoot;
  };

  hasDisabledPlugins = builtins.length cfg.disabledPlugins > 0;

in
{
  imports = [
    (mkRenamedOptionModule [ "hardware" "bluetooth" "config" ] [ "hardware" "bluetooth" "settings" ])
    (mkRemovedOptionModule [ "hardware" "bluetooth" "extraConfig" ] ''
      Use hardware.bluetooth.settings instead.

      This is part of the general move to use structured settings instead of raw
      text for config as introduced by RFC0042:
      https://github.com/NixOS/rfcs/blob/master/rfcs/0042-config-option.md
    '')
  ];

  ###### interface

  options = {

    hardware.bluetooth = {
      enable = mkEnableOption "support for Bluetooth";

      hsphfpd.enable = mkEnableOption "support for hsphfpd[-prototype] implementation";

      powerOnBoot = mkOption {
        type = types.either types.bool (types.enum [ "auto" ]);
        default = true;
        description = ''
          Whether to power up the default Bluetooth controller on boot.

          When set to `"auto"`, the power state from the last session is
          restored on boot: if Bluetooth was on when the system shut down,
          it will be powered on; if it was off, it will stay off.

          The state is snapshotted at shutdown to
          `/var/lib/bluetooth/power-state` and re-applied at next boot
          via `rfkill block`. The rfkill route is needed because some
          platforms (e.g. `thinkpad_acpi` on Lenovo ThinkPads) reset
          rfkill state on boot, overriding systemd-rfkill's restoration,
          and because rfkill hides the adapter from bluez's D-Bus tree
          so that clients (PipeWire/WirePlumber, gnome-bluetooth, ...)
          cannot auto-power it back on.
        '';
      };

      package = mkPackageOption pkgs "bluez" { };

      disabledPlugins = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Built-in plugins to disable";
      };

      settings = mkOption {
        type = cfgFmt.type;
        default = { };
        example = {
          General = {
            ControllerMode = "bredr";
          };
        };
        description = ''
          Set configuration for system-wide bluetooth (/etc/bluetooth/main.conf).
          See <https://github.com/bluez/bluez/blob/master/src/main.conf> for full list of options.
        '';
      };

      input = mkOption {
        type = cfgFmt.type;
        default = { };
        example = {
          General = {
            IdleTimeout = 30;
            ClassicBondedOnly = true;
          };
        };
        description = ''
          Set configuration for the input service (/etc/bluetooth/input.conf).
          See <https://github.com/bluez/bluez/blob/master/profiles/input/input.conf> for full list of options.
        '';
      };

      network = mkOption {
        type = cfgFmt.type;
        default = { };
        example = {
          General = {
            DisableSecurity = true;
          };
        };
        description = ''
          Set configuration for the network service (/etc/bluetooth/network.conf).
          See <https://github.com/bluez/bluez/blob/master/profiles/network/network.conf> for full list of options.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ package ] ++ optional cfg.hsphfpd.enable pkgs.hsphfpd;

    environment.etc."bluetooth/input.conf".source = cfgFmt.generate "input.conf" cfg.input;
    environment.etc."bluetooth/network.conf".source = cfgFmt.generate "network.conf" cfg.network;
    environment.etc."bluetooth/main.conf".source = cfgFmt.generate "main.conf" (
      recursiveUpdate defaults cfg.settings
    );
    services.udev.packages = [ package ];
    services.dbus.packages = [ package ] ++ optional cfg.hsphfpd.enable pkgs.hsphfpd;
    systemd.packages = [ package ];

    systemd.services = {
      bluetooth =
        let
          # `man bluetoothd` will refer to main.conf in the nix store but bluez
          # will in fact load the configuration file at /etc/bluetooth/main.conf
          # so force it here to avoid any ambiguity and things suddenly breaking
          # if/when the bluez derivation is changed.
          args = [
            "-f"
            "/etc/bluetooth/main.conf"
          ]
          ++ optional hasDisabledPlugins "--noplugin=${concatStringsSep "," cfg.disabledPlugins}";
        in
        {
          wantedBy = [ "bluetooth.target" ];
          aliases = [ "dbus-org.bluez.service" ];
          # restarting can leave people without a mouse/keyboard
          restartIfChanged = false;
          serviceConfig = {
            ExecStart = [
              ""
              "${package}/libexec/bluetooth/bluetoothd ${utils.escapeSystemdExecArgs args}"
            ];
            CapabilityBoundingSet = [
              "CAP_NET_BIND_SERVICE" # sockets and tethering
            ];
            ConfigurationDirectoryMode = "0755";
            NoNewPrivileges = true;
            RestrictNamespaces = true;
            ProtectControlGroups = true;
            MemoryDenyWriteExecute = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = "@system-service";
            LockPersonality = true;
            RestrictRealtime = true;
            ProtectProc = "invisible";
            PrivateTmp = true;

            PrivateUsers = false;

            # loading hardware modules
            ProtectKernelModules = false;
            ProtectKernelTunables = false;

            PrivateNetwork = false; # tethering
          };
        };
    }
    // (optionalAttrs persistPowerState {
      bluetooth-persist-power-state = {
        description = "Persist Bluetooth power state across reboots";
        after = [ "bluetooth.service" ];
        requires = [ "bluetooth.service" ];
        partOf = [ "bluetooth.service" ];
        wantedBy = [ "bluetooth.target" ];
        # Snapshot the current power state at shutdown and re-apply it at
        # next boot via rfkill block. rfkill hides the adapter from bluez's
        # D-Bus tree, so neither bluez's Policy.AutoEnable nor clients
        # (PipeWire/WirePlumber, gnome-bluetooth, auto-reconnecting paired
        # devices, ...) can power it back on. Re-applying at boot is
        # necessary because some platforms (e.g. thinkpad_acpi on Lenovo
        # ThinkPads) reset rfkill state on boot, overriding systemd-rfkill.
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          StateDirectory = "bluetooth";
          ExecStart = pkgs.writeShellScript "bluetooth-restore-power-state" ''
            if [ "$(cat /var/lib/bluetooth/power-state 2>/dev/null)" = "off" ]; then
              ${pkgs.util-linux}/bin/rfkill block bluetooth
            fi
          '';
          # Runs before bluetooth.service stops (After= reverses on stop),
          # so bluez is still reachable for the Powered query.
          ExecStop = pkgs.writeShellScript "bluetooth-save-power-state" ''
            state=on
            rfkill_state=$(${pkgs.util-linux}/bin/rfkill list bluetooth)
            bluez_state=$(${package}/bin/bluetoothctl show 2>/dev/null || true)
            if [[ "$rfkill_state" == *"Soft blocked: yes"* ]]; then
              state=off
            elif [[ "$bluez_state" == *"Powered: no"* ]]; then
              state=off
            fi
            echo "$state" > /var/lib/bluetooth/power-state
          '';
        };
      };
    })
    // (optionalAttrs cfg.hsphfpd.enable {
      hsphfpd = {
        after = [ "bluetooth.service" ];
        requires = [ "bluetooth.service" ];
        wantedBy = [ "bluetooth.target" ];

        description = "A prototype implementation used for connecting HSP/HFP Bluetooth devices";
        serviceConfig.ExecStart = "${pkgs.hsphfpd}/bin/hsphfpd.pl";
      };
    });

    systemd.user.services = {
      obex.aliases = [ "dbus-org.bluez.obex.service" ];
    }
    // optionalAttrs cfg.hsphfpd.enable {
      telephony_client = {
        wantedBy = [ "default.target" ];

        description = "telephony_client for hsphfpd";
        serviceConfig.ExecStart = "${pkgs.hsphfpd}/bin/telephony_client.pl";
      };
    };
  };
}
