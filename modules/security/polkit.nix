{ config, pkgs, ... }:

with pkgs.lib;

{

  config = {

    environment.systemPackages = [ pkgs.polkit ];

    services.dbus.packages = [ pkgs.polkit ];

    security.pam.services = [ { name = "polkit-1"; } ];

    security.setuidPrograms = [ "pkexec" ];

    system.activationScripts.policyKit = pkgs.stringsWithDeps.noDepEntry
      ''
        mkdir -p /var/lib/polkit-1
      '';

  };

}
