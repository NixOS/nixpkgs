{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.gdnc;
  gnustepConf = pkgs.writeText "GNUstep.conf" ''
    GNUSTEP_USER_CONFIG_FILE=.GNUstep.conf
    GNUSTEP_USER_DIR=GNUstep
    GNUSTEP_USER_DEFAULTS_DIR=GNUstep/Defaults
    GNUSTEP_MAKEFILES=${pkgs.gnustep_make}/share/GNUstep/Makefiles
    
    GNUSTEP_SYSTEM_USERS_DIR=/homeless-shelter
    GNUSTEP_NETWORK_USERS_DIR=/homeless-shelter
    GNUSTEP_LOCAL_USERS_DIR=/homeless-shelter
    
    GNUSTEP_SYSTEM_APPS=${pkgs.gnustep_base}/lib/GNUstep/Applications
    GNUSTEP_SYSTEM_ADMIN_APPS=${pkgs.gnustep_base}/lib/GNUstep/Applications
    GNUSTEP_SYSTEM_WEB_APPS=${pkgs.gnustep_base}/lib/GNUstep/WebApplications
    GNUSTEP_SYSTEM_TOOLS=${pkgs.gnustep_base}/bin
    GNUSTEP_SYSTEM_ADMIN_TOOLS=${pkgs.gnustep_base}/sbin
    GNUSTEP_SYSTEM_LIBRARY=${pkgs.gnustep_base}/lib/GNUstep
    GNUSTEP_SYSTEM_HEADERS=${pkgs.gnustep_base}/include
    GNUSTEP_SYSTEM_LIBRARIES=${pkgs.gnustep_base}/lib
    GNUSTEP_SYSTEM_DOC=${pkgs.gnustep_base}/share/GNUstep/Documentation
    GNUSTEP_SYSTEM_DOC_MAN=${pkgs.gnustep_base}/share/man
    GNUSTEP_SYSTEM_DOC_INFO=${pkgs.gnustep_base}/share/info
    
    GNUSTEP_NETWORK_APPS=${pkgs.gnustep_base}/lib/GNUstep/Applications
    GNUSTEP_NETWORK_ADMIN_APPS=${pkgs.gnustep_base}/lib/GNUstep/Applications
    GNUSTEP_NETWORK_WEB_APPS=${pkgs.gnustep_base}/lib/GNUstep/WebApplications
    GNUSTEP_NETWORK_TOOLS=${pkgs.gnustep_base}/bin
    GNUSTEP_NETWORK_ADMIN_TOOLS=${pkgs.gnustep_base}/sbin
    GNUSTEP_NETWORK_LIBRARY=${pkgs.gnustep_base}/lib/GNUstep
    GNUSTEP_NETWORK_HEADERS=${pkgs.gnustep_base}/include
    GNUSTEP_NETWORK_LIBRARIES=${pkgs.gnustep_base}/lib
    GNUSTEP_NETWORK_DOC=${pkgs.gnustep_base}/share/GNUstep/Documentation
    GNUSTEP_NETWORK_DOC_MAN=${pkgs.gnustep_base}/share/man
    GNUSTEP_NETWORK_DOC_INFO=${pkgs.gnustep_base}/share/info

    GNUSTEP_LOCAL_APPS=${pkgs.gnustep_base}/lib/GNUstep/Applications
    GNUSTEP_LOCAL_ADMIN_APPS=${pkgs.gnustep_base}/lib/GNUstep/Applications
    GNUSTEP_LOCAL_WEB_APPS=${pkgs.gnustep_base}/lib/GNUstep/WebApplications
    GNUSTEP_LOCAL_TOOLS=${pkgs.gnustep_base}/bin
    GNUSTEP_LOCAL_ADMIN_TOOLS=${pkgs.gnustep_base}/sbin
    GNUSTEP_LOCAL_LIBRARY=${pkgs.gnustep_base}/lib/GNUstep
    GNUSTEP_LOCAL_HEADERS=${pkgs.gnustep_base}/include
    GNUSTEP_LOCAL_LIBRARIES=${pkgs.gnustep_base}/lib
    GNUSTEP_LOCAL_DOC=${pkgs.gnustep_base}/share/GNUstep/Documentation
    GNUSTEP_LOCAL_DOC_MAN=${pkgs.gnustep_base}/share/man
    GNUSTEP_LOCAL_DOC_INFO=${pkgs.gnustep_base}/share/info

    GNUSTEP_USER_DIR_APPS=GNUstep/Applications
    GNUSTEP_USER_DIR_ADMIN_APPS=GNUstep/Applications/Admin
    GNUSTEP_USER_DIR_WEB_APPS=GNUstep/WebApplications
    GNUSTEP_USER_DIR_TOOLS=GNUstep/Tools
    GNUSTEP_USER_DIR_ADMIN_TOOLS=GNUstep/Tools/Admin
    GNUSTEP_USER_DIR_LIBRARY=GNUstep/Library
    GNUSTEP_USER_DIR_HEADERS=GNUstep/Library/Headers
    GNUSTEP_USER_DIR_LIBRARIES=GNUstep/Library/Libraries
    GNUSTEP_USER_DIR_DOC=GNUstep/Library/Documentation
    GNUSTEP_USER_DIR_DOC_MAN=GNUstep/Library/Documentation/man
    GNUSTEP_USER_DIR_DOC_INFO=GNUstep/Library/Documentation/info
  '';
in {
  options = {
    services.gdnc.enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable gdnc, the GNUstep distributed notification center";
    };
  };
  config = mkIf cfg.enable {
    assertions = singleton {
      assertion = config.services.gdnc.enable -> config.services.gdomap.enable;
      message = "Cannot start gdnc without starting gdomap";
    };
    environment = {
      systemPackages = [ pkgs.gnustep_make pkgs.gnustep_base ];
    };
    systemd.services.gdnc = {
      path = [ pkgs.gnustep_make pkgs.gnustep_base ];
      description = "gdnc: GNUstep distributed notification center";
      requires = [ "gdomap.service" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        export GNUSTEP_MAKEFILES=${pkgs.gnustep_make}/share/GNUstep/Makefiles
      	export GNUSTEP_CONFIG_FILE=${gnustepConf}
	. $GNUSTEP_MAKEFILES/GNUstep.sh      
      '';
      serviceConfig = {
        ExecStart = "@${pkgs.gnustep_base}/bin/gdnc --verbose --no-fork";
        Restart = "always";
	RestartSec = 2;
	TimeoutStartSec = "30";
	Type = "forking";
      };
    };
  };
}