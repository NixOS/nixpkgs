{ config, lib, pkgs, ... }:

let
  cfg = config.services.hardware.argonone;
in
{
  options.services.hardware.argonone = {
    enable = lib.mkEnableOption (lib.mdDoc "the driver for Argon One Raspberry Pi case fan and power button");
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.argononed;
      defaultText = "pkgs.argononed";
      description = lib.mdDoc ''
        The package implementing the Argon One driver
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.i2c.enable = true;
    hardware.deviceTree.overlays = [
      {
        name = "argononed";
        dtboFile = "${cfg.package}/boot/overlays/argonone.dtbo";
      }
      {
        name = "i2c1-okay-overlay";
        dtsText = ''
          /dts-v1/;
          /plugin/;
          / {
            compatible = "brcm,bcm2711";
            fragment@0 {
              target = <&i2c1>;
              __overlay__ {
                status = "okay";
              };
            };
          };
        '';
      }
    ];
    environment.systemPackages = [ cfg.package ];
    systemd.services.argononed = {
      description = "Argon One Raspberry Pi case Daemon Service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        ExecStart = "${cfg.package}/bin/argononed";
        PIDFile = "/run/argononed.pid";
        Restart = "on-failure";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ misterio77 ];

}
