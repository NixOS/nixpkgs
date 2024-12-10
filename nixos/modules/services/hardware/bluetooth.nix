{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.bluetooth;
  package = cfg.package;

  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    mkRenamedOptionModule
    mkRemovedOptionModule
    concatStringsSep
    escapeShellArgs
    literalExpression
    optional
    optionals
    optionalAttrs
    recursiveUpdate
    types
    ;

  cfgFmt = pkgs.formats.ini { };

  defaults = {
    General.ControllerMode = "dual";
    Policy.AutoEnable = cfg.powerOnBoot;
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
        type = types.bool;
        default = true;
        description = "Whether to power up the default Bluetooth controller on boot.";
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
        description = "Set configuration for system-wide bluetooth (/etc/bluetooth/main.conf).";
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
        description = "Set configuration for the input service (/etc/bluetooth/input.conf).";
      };

      network = mkOption {
        type = cfgFmt.type;
        default = { };
        example = {
          General = {
            DisableSecurity = true;
          };
        };
        description = "Set configuration for the network service (/etc/bluetooth/network.conf).";
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

    systemd.services =
      {
        bluetooth =
          let
            # `man bluetoothd` will refer to main.conf in the nix store but bluez
            # will in fact load the configuration file at /etc/bluetooth/main.conf
            # so force it here to avoid any ambiguity and things suddenly breaking
            # if/when the bluez derivation is changed.
            args = [
              "-f"
              "/etc/bluetooth/main.conf"
            ] ++ optional hasDisabledPlugins "--noplugin=${concatStringsSep "," cfg.disabledPlugins}";
          in
          {
            wantedBy = [ "bluetooth.target" ];
            aliases = [ "dbus-org.bluez.service" ];
            serviceConfig.ExecStart = [
              ""
              "${package}/libexec/bluetooth/bluetoothd ${escapeShellArgs args}"
            ];
            # restarting can leave people without a mouse/keyboard
            unitConfig.X-RestartIfChanged = false;
          };
      }
      // (optionalAttrs cfg.hsphfpd.enable {
        hsphfpd = {
          after = [ "bluetooth.service" ];
          requires = [ "bluetooth.service" ];
          wantedBy = [ "bluetooth.target" ];

          description = "A prototype implementation used for connecting HSP/HFP Bluetooth devices";
          serviceConfig.ExecStart = "${pkgs.hsphfpd}/bin/hsphfpd.pl";
        };
      });

    systemd.user.services =
      {
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
