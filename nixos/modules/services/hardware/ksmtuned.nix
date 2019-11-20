#
{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.ksmtuned;

in
{
  options.services.ksmtuned.enable = mkEnableOption "ksmtuned daemon";

  config = mkIf cfg.enable {

    systemd.services = {
      ksmtuned = {
        description = "Kernel Samepage Merging (KSM) Tuning Daemon";
        path = [ pkgs.ksmtuned ];
	unitConfig.ConditionVirtualization = "no";
	after = [ "ksm.service" ];
	requires = [ "ksm.service" ];
        serviceConfig = {
          ExecStart = "${pkgs.ksmtuned}/bin/ksmtuned";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };

    environment.systemPackages = [ pkgs.ksmtuned ];

  };

}
