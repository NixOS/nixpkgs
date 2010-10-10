{ config, pkgs, ... }:

with pkgs.lib;

let
  pkWrapper = pkgs.stdenv.mkDerivation {
    name = "polkit-wrapper";
    helper = "libexec/polkit-1/polkit-agent-helper-1";
    buildInputs = [ pkgs.xorg.lndir ];

    builder = pkgs.writeScript "pkwrap-builder" ''
      source $stdenv/setup

      mkdir -pv $out
      lndir ${pkgs.polkit} $out

      rm $out/$helper
      ln -sv ${config.security.wrapperDir}/polkit-agent-helper-1 $out/$helper
      '';
  };
in

{

  config = {

    environment = {
      systemPackages = [ pkWrapper ];
      pathsToLink = [ "/share/polkit-1" "/etc/polkit-1" ];
      etc = singleton
        { source = "${config.system.path}/etc/polkit-1";
          target = "polkit-1";
        };
    };

    services.dbus.packages = [ pkWrapper ];

    security = {
      pam.services = [ { name = "polkit-1"; } ];
      setuidPrograms = [ "pkexec" ];

      setuidOwners = singleton
        { program = "polkit-agent-helper-1";
          owner = "root";
          group = "root";
          setuid = true;
          source = pkgs.polkit + "/" + pkWrapper.helper;
        };
    };

    system.activationScripts.polkit =
      ''
        mkdir -p /var/lib/polkit-1/localauthority
        chmod 700 /var/lib/polkit-1{/localauthority,}
      '';
  };

}
