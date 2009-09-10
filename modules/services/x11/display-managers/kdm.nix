{pkgs, config, ...}:

with pkgs.lib;

let

  dmcfg = config.services.xserver.displayManager;
  cfg = dmcfg.kdm;

  inherit (pkgs.kde42) kdebase_workspace;

  defaultConfig =
    ''
      [Shutdown]
      HaltCmd=${pkgs.upstart}/sbin/halt
      RebootCmd=${pkgs.upstart}/sbin/reboot

      [X-*-Core]
      Xrdb=${pkgs.xlibs.xrdb}/bin/xrdb
      SessionsDirs=${dmcfg.session.desktops}
      FailsafeClient=${pkgs.xterm}/bin/xterm

      [X-:*-Core]
      ServerCmd=${dmcfg.xserverBin} ${dmcfg.xserverArgs}

      [X-*-Greeter]
      HiddenUsers=root,nixbld1,nixbld2,nixbld3,nixbld4,nixbld5,nixbld6,nixbld7,nixbld8,nixbld9,nixbld10
      PluginsLogin=${kdebase_workspace}/lib/kde4/kgreet_classic.so
    '';

  kdmrc = pkgs.stdenv.mkDerivation {
    name = "kdmrc";
    config = defaultConfig + cfg.extraConfig;
    buildCommand =
      ''
        echo "$config" > $out
        cat ${kdebase_workspace}/share/config/kdm/kdmrc >> $out
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

      extraConfig = mkOption {
        default = "";
        description = ''
          Options appended to <filename>kdmrc</filename>, the
          configuration file of KDM.
        '';
      };
      
    };

  };
  
  
  ###### implementation
  
  config = mkIf cfg.enable {
  
    services.xserver.displayManager.job =
      { execCmd = "${kdebase_workspace}/bin/kdm -config ${kdmrc}";
      };

    security.pam.services = [ { name = "kde"; localLogin = true; ckHack = true; } ];
      
  };
  
}
