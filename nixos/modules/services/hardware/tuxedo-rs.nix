{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.tuxedo-rs;

in
{
  options = {
    hardware.tuxedo-rs = {
      enable = mkEnableOption (lib.mdDoc "Rust utilities for interacting with hardware from TUXEDO Computers");

      tailor-gui.enable = mkEnableOption (lib.mdDoc "tailor-gui, an alternative to TUXEDO Control Center, written in Rust");
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hardware.tuxedo-keyboard.enable = true;

      systemd = {
        services.tailord = {
          enable = true;
          description = "Tuxedo Tailor hardware control service";
          after = [ "systemd-logind.service" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            Type = "dbus";
            BusName = "com.tux.Tailor";
            ExecStart = "${pkgs.tuxedo-rs}/bin/tailord";
            Environment = "RUST_BACKTRACE=1";
            Restart = "on-failure";
          };
        };
      };

      services.dbus.packages = [ pkgs.tuxedo-rs ];

      environment.systemPackages = [ pkgs.tuxedo-rs ];
    }
    (mkIf cfg.tailor-gui.enable {
      environment.systemPackages = [ pkgs.tailor-gui ];
    })
  ]);

  meta.maintainers = with maintainers; [ mrcjkb ];
}
