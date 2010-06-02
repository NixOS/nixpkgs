# Configuration for the pwdutils suite of tools: passwd, useradd, etc.

{config, pkgs, ...}:

let

in

{

  ###### interface
  
  options = {

    users.defaultUserShell = pkgs.lib.mkOption {
      default = "/var/run/current-system/sw/bin/bash";
      description = ''
        This option defined the default shell assigned to user
        accounts.  This must not be a store path, since the path is
        used outside the store (in particular in /etc/passwd).
        Rather, it should be the path of a symlink that points to the
        actual shell in the Nix store.
      '';
    };
  
  };

  
  ###### implementation

  config = {

    environment.systemPackages = [ pkgs.shadow ];

    environment.etc =
      [ { # /etc/login.defs: global configuration for pwdutils.  You
          # cannot login without it! 
          source = ./login.defs;
          target = "login.defs";
        } 

        { # /etc/default/useradd: configuration for useradd.
          source = pkgs.writeText "useradd"
            ''
              GROUP=100
              HOME=/home
              SHELL=${config.users.defaultUserShell}
            '';
          target = "default/useradd";
        }
      ];

    security.pam.services =
      [ { name = "chsh"; rootOK = true; }
        { name = "chfn"; rootOK = true; }
        { name = "su"; rootOK = true; forwardXAuth = true; }
        { name = "passwd"; }
        # Note: useradd, groupadd etc. aren't setuid root, so it
        # doesn't really matter what the PAM config says as long as it
        # lets root in.
        { name = "useradd"; rootOK = true; }
        { name = "usermod"; rootOK = true; }
        { name = "userdel"; rootOK = true; }
        { name = "groupadd"; rootOK = true; }
        { name = "groupmod"; rootOK = true; } 
        { name = "groupmems"; rootOK = true; }
        { name = "groupdel"; rootOK = true; }
        { name = "login"; ownDevices = true; allowNullPassword = true;
          limits = config.security.pam.loginLimits;
        }
      ];
      
    security.setuidPrograms = [ "passwd" "chfn" "su" ];
    
  };
  
}
