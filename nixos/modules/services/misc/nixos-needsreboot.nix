{ config, lib, pkgs, ... }:
let
  cfg = config.services.nixos-needsreboot;
in
{
  options = {
    services.nixos-needsreboot = {
      enable = lib.mkEnableOption "nixos-needsreboot, which determines if you need to reboot your NixOS machine";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = config.system.autoUpgrade.enable == true;
      message  = "Please enable 'system.autoUpgrade'.";
    }];

    systemd.services.nixos-needsreboot = {
      description = "Determine if you need to reboot your NixOS machine";
      requires = [ "nixos-upgrade.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = lib.getExe pkgs.nixos-needsreboot;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ thefossguy ];
}
