{ config, pkgs, ... }:

with pkgs.lib;

{

  config = {

    environment.systemPackages = [ pkgs.policy_kit ];

    services.dbus.packages = [ pkgs.policy_kit ];

    security.pam.services = [ { name = "polkit-1"; } ];

    security.setuidPrograms = [ "pkexec" ];

    system.activationScripts.policyKit = pkgs.stringsWithDeps.noDepEntry
      ''
        mkdir -p /var/lib/polkit-1
      '';

  };

}