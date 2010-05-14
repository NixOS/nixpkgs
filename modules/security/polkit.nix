{ config, pkgs, ... }:

with pkgs.lib;

let
  pkWrapper = pkgs.stdenv.mkDerivation {
    name = "polkit-wrapper";
    helper = "polkit-agent-helper-1";
    buildInputs = [ pkgs.xorg.lndir ];

    builder = pkgs.writeScript "pkwrap-builder" ''
      source $stdenv/setup

      mkdir -p $out
      lndir ${pkgs.polkit} $out
      new=$out/libexec/$helper

      mv $new $out/libexec/.$helper.orig
      echo "exec ${config.security.wrapperDir}/$helper \"\$@\"" > $new
      chmod +x $new
      '';
  };
in

{

  config = {

    environment = {
      systemPackages = [ pkWrapper ];
      pathsToLink = [ "/share/polkit-1" "/etc/polkit-1" ];
      etc = [
        {
          source = "${config.system.path}/etc/polkit-1";
          target = "polkit-1";
        }
      ];
    };

    services.dbus.packages = [ pkWrapper ];

    security = {
      pam.services = [ { name = "polkit-1"; } ];
      setuidPrograms = [ "pkexec" ];

      setuidOwners = [
        {
          program = pkWrapper.helper;
          owner = "root";
          group = "root";
          setuid = true;
          source = pkWrapper + "/libexec/." + pkWrapper.helper + ".orig";
        }
      ];
    };

    system.activationScripts.policyKit = pkgs.stringsWithDeps.noDepEntry
      ''
        mkdir -p /var/lib/polkit-1
        chmod 700 /var/lib/polkit-1
      '';
  };

}
