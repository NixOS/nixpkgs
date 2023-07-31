{ pkgs, config, lib, ... }:

let
  cfg = config.boot.initrd.systemd.ultrablue;
in
{
  options.boot.initrd.systemd.ultrablue = {
    enable = lib.mkEnableOption (lib.mdDoc "the Ultrablue remote attestation server");
    package = (lib.mkPackageOptionMD pkgs "Ultrablue server package" {
      default = "ultrablue-server";
    });
  };
  config = lib.mkIf cfg.enable {
    boot.initrd.systemd = {
      storePaths = [
        "${cfg.package}/bin/ultrablue-server"
        "${pkgs.toybox}/bin/sleep"
      ];

      services.ultrablue-server = {
        after = [ "bluetooth.service" ];
        wants = [ "bluetooth.service" "cryptsetup-pre.target" ];
        before = [ "cryptsetup.target" ];
        wantedBy = [ "cryptsetup.target" ];

        unitConfig.DefaultDependencies = false;

        serviceConfig = {
          Type = "oneshot";
          # TODO: upstream hack, brrr
          ExecStartPre = "${pkgs.toybox}/bin/sleep 5";
          ExecStart = "${cfg.package}/bin/ultrablue-server";
          TimeoutSec = 60;
          StandardOutput = "tty";
        };
      };
    };
  };
}
