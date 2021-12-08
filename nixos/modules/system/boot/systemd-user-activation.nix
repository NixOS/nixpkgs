{ config, lib, pkgs, ... }:

{
  config = {
    systemd.user = {
      services.nixos-activation = {
        description = "Run user-specific NixOS activation";
        script = config.system.userActivationScripts.script;
        unitConfig.ConditionUser = "!@system";
        serviceConfig.Type = "oneshot";
        wantedBy = [ "default.target" ];
      };
    };
  };
}
