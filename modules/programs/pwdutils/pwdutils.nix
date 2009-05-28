# Configuration for the pwdutils suite of tools: passwd, useradd, etc.

{config, pkgs, ...}:

let

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

in

{
  require = [options];

  environment.etc =
    [ { # /etc/login.defs: global configuration for pwdutils.  You
        # cannot login without it! 
        source = ./login.defs;
        target = "login.defs";
      } 

      { # /etc/default/passwd: configuration for passwd and friends
        # (e.g., hash algorithm for /etc/passwd).
        source = ./passwd.conf;
        target = "default/passwd";
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
}
