{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.bluetooth;
  bluez-bluetooth = cfg.package;

in {

  ###### interface

  options = {

    hardware.bluetooth = {
      enable = mkEnableOption "support for Bluetooth";

      hsphfpd.enable = mkEnableOption "support for hsphfpd[-prototype] implementation";

      powerOnBoot = mkOption {
        type    = types.bool;
        default = true;
        description = "Whether to power up the default Bluetooth controller on boot.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.bluez;
        defaultText = "pkgs.bluez";
        example = "pkgs.bluezFull";
        description = ''
          Which BlueZ package to use.

          <note><para>
            Use the <literal>pkgs.bluezFull</literal> package to enable all
            bluez plugins.
          </para></note>
        '';
      };

      config = mkOption {
        type = with types; attrsOf (attrsOf (oneOf [ bool int str ]));
        example = {
          General = {
            ControllerMode = "bredr";
          };
        };
        description = "Set configuration for system-wide bluetooth (/etc/bluetooth/main.conf).";
      };

      extraConfig = mkOption {
        type = with types; nullOr lines;
        default = null;
        example = ''
          [General]
          ControllerMode = bredr
        '';
        description = ''
          Set additional configuration for system-wide bluetooth (/etc/bluetooth/main.conf).
        '';
      };
    };

  };

  ###### implementation

  config = mkIf cfg.enable {
    warnings = optional (cfg.extraConfig != null) "hardware.bluetooth.`extraConfig` is deprecated, please use hardware.bluetooth.`config`.";

    hardware.bluetooth.config = {
      Policy = {
        AutoEnable = mkDefault cfg.powerOnBoot;
      };
    };

    environment.systemPackages = [ bluez-bluetooth ]
      ++ optionals cfg.hsphfpd.enable [ pkgs.hsphfpd ];

    environment.etc."bluetooth/main.conf"= {
      source = pkgs.writeText "main.conf"
        (generators.toINI { } cfg.config + optionalString (cfg.extraConfig != null) cfg.extraConfig);
    };

    services.udev.packages = [ bluez-bluetooth ];
    services.dbus.packages = [ bluez-bluetooth ]
      ++ optionals cfg.hsphfpd.enable [ pkgs.hsphfpd ];
    systemd.packages       = [ bluez-bluetooth ];

    systemd.services = {
      bluetooth = {
        wantedBy = [ "bluetooth.target" ];
        aliases  = [ "dbus-org.bluez.service" ];
        # restarting can leave people without a mouse/keyboard
        unitConfig.X-RestartIfChanged = false;
      };
    }
      // (optionalAttrs cfg.hsphfpd.enable {
        hsphfpd = {
          after = [ "bluetooth.service" ];
          requires = [ "bluetooth.service" ];
          wantedBy = [ "multi-user.target" ];

          description = "A prototype implementation used for connecting HSP/HFP Bluetooth devices";
          serviceConfig.ExecStart = "${pkgs.hsphfpd}/bin/hsphfpd.pl";
        };
      })
      ;

    systemd.user.services = {
      obex.aliases = [ "dbus-org.bluez.obex.service" ];
    }
      // (optionalAttrs cfg.hsphfpd.enable {
        telephony_client = {
          wantedBy = [ "default.target"];

          description = "telephony_client for hsphfpd";
          serviceConfig.ExecStart = "${pkgs.hsphfpd}/bin/telephony_client.pl";
        };
      })
      ;

  };

}
