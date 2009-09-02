{pkgs, config, ...}:

with pkgs.lib;

let

  dmcfg = config.services.xserver.displayManager;
  cfg = dmcfg.kdm;

  inherit (pkgs.kde42) kdebase_workspace;

  kdmrc = pkgs.stdenv.mkDerivation {
    name = "kdmrc";
    # -e "s|Session=${kdebase_workspace}/share/config/kdm/Xsession|Session=${dmcfg.session.script}|" \
    buildCommand = ''
      cp ${kdebase_workspace}/share/config/kdm/kdmrc .
      sed -i -e "s|#HaltCmd=|HaltCmd=${pkgs.upstart}/sbin/halt|" \
             -e "s|#RebootCmd=|RebootCmd=${pkgs.upstart}/sbin/reboot|" \
	     -e "s|#Xrdb=|Xrdb=${pkgs.xlibs.xrdb}/bin/xrdb|" \
	     -e "s|#HiddenUsers=root|HiddenUsers=root,nixbld1,nixbld2,nixbld3,nixbld4,nixbld5,nixbld6,nixbld7,nixbld8,nixbld9,nixbld10|" \
	     -e "s|ServerCmd=/FOO/bin/X|ServerCmd=${dmcfg.xserverBin} ${dmcfg.xserverArgs}|" \
 	     -e "s|^SessionsDirs=.*$|SessionsDirs=${dmcfg.session.desktops}|" \
	     -e "s|#FailsafeClient=|FailsafeClient=${pkgs.xterm}/bin/xterm|" \
	     -e "s|#PluginsLogin=sign|PluginsLogin=${kdebase_workspace}/lib/kde4/kgreet_classic.so|" \
      kdmrc
      ensureDir $out
      cp kdmrc $out
    '';
  };

in

{

  ###### interface
  
  options = {

    services.xserver.displayManager.kdm = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable the KDE display manager.
        '';
      };
    };

  };
  
  
  ###### implementation
  
  config = mkIf cfg.enable {
  
    services.xserver.displayManager.job =
      { beforeScript = "";
        env = "";
        execCmd = "${kdebase_workspace}/bin/kdm -config ${kdmrc}/kdmrc";
      };

    security.pam.services = [ { name = "kde"; localLogin = true; } ];
      
  };
  
}
