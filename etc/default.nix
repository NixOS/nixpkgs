{ config, pkgs, upstartJobs, systemPath, wrapperDir
, defaultShell, extraEtc, nixEnvVars, modulesTree, nssModulesPath, binsh
}:

let 


  optional = pkgs.lib.optional;


  # !!! ugh, these files shouldn't be created here.
    
    
  pamConsoleHandlers = pkgs.writeText "console.handlers" ''
    console consoledevs /dev/tty[0-9][0-9]* :[0-9]\.[0-9] :[0-9]
    ${pkgs.pam_console}/sbin/pam_console_apply lock logfail wait -t tty -s -c ${pamConsolePerms}
    ${pkgs.pam_console}/sbin/pam_console_apply unlock logfail wait -r -t tty -s -c ${pamConsolePerms}
  '';

  pamConsolePerms = ./security/console.perms;

  
in

    
import ../helpers/make-etc.nix {
  inherit (pkgs) stdenv;

  configFiles = [
    { # TCP/UDP port assignments.
      source = pkgs.iana_etc + "/etc/services";
      target = "services";
    }

    { # IP protocol numbers.
      source = pkgs.iana_etc + "/etc/protocols";
      target = "protocols";
    }

    { # RPC program numbers.
      source = pkgs.glibc + "/etc/rpc";
      target = "rpc";
    }

    { # Hostname-to-IP mappings.
      source = pkgs.substituteAll {
        src = ./hosts;
        extraHosts = config.networking.extraHosts;
      };
      target = "hosts";
    }

    { # Name Service Switch configuration file.  Required by the C library.
      source = if config.services.avahi.nssmdns
               then (assert config.services.avahi.enable; ./nsswitch-mdns.conf)
               else ./nsswitch.conf;
      target = "nsswitch.conf";
    }

    { # Friendly greeting on the virtual consoles.
      source = pkgs.writeText "issue" ''
      
        [1;32m${config.services.mingetty.greetingLine}[0m
        ${config.services.mingetty.helpLine}
        
      '';
      target = "issue";
    }

    { # Configuration for pwdutils (login, passwd, useradd, etc.).
      # You cannot login without it!
      source = ./login.defs;
      target = "login.defs";
    }

    { # The Upstart events defined above.
      source = upstartJobs + "/etc/event.d";
      target = "event.d";
    }

    { # Configuration for passwd and friends (e.g., hash algorithm
      # for /etc/passwd).
      source = ./default/passwd;
      target = "default/passwd";
    }

    { # Configuration for useradd.
      source = pkgs.substituteAll {
        src = ./default/useradd;
        inherit defaultShell;
      };
      target = "default/useradd";
    }

    { # Dhclient hooks for emitting ip-up/ip-down events.
      source = pkgs.substituteAll {
        src = ./dhclient-exit-hooks;
        inherit (pkgs) upstart glibc;
      };
      target = "dhclient-exit-hooks";
    }

    { # Script executed when the shell starts as a non-login shell (system-wide version).
      source = pkgs.substituteAll {
        src = ./bashrc.sh;
        inherit systemPath wrapperDir modulesTree nssModulesPath;
        inherit (pkgs) glibc;
        timeZone = config.time.timeZone;
        defaultLocale = config.i18n.defaultLocale;
        inherit nixEnvVars;
      };
      target = "bashrc";      
    }

    { # Script executed when the shell starts as a login shell.
      source = ./profile.sh;
      target = "profile";
    }

    { # Configuration for readline in bash.
      source = ./inputrc;
      target = "inputrc";
    }

    { # Nix configuration.
      source =
        let
          # Tricky: if we're using a chroot for builds, then we need
          # /bin/sh in the chroot (our own compromise to purity).
          # However, since /bin/sh is a symlink to some path in the
          # Nix store, which furthermore has runtime dependencies on
          # other paths in the store, we need the closure of /bin/sh
          # in `build-chroot-dirs' - otherwise any builder that uses
          # /bin/sh won't work.
          binshDeps = pkgs.writeReferencesToFile binsh;

          # Likewise, if chroots are turned on, we need Nix's own
          # closure in the chroot.  Otherwise nix-channel and nix-env
          # won't work because the dependencies of its builders (like
          # coreutils and Perl) aren't visible.  Sigh.
          nixDeps = pkgs.writeReferencesToFile config.environment.nix;
        in 
          pkgs.runCommand "nix.conf" {extraOptions = config.nix.extraOptions; } ''
            extraPaths=$(for i in $(cat ${binshDeps} ${nixDeps}); do if test -d $i; then echo $i; fi; done)
            cat > $out <<END
            # WARNING: this file is generated.
            build-users-group = nixbld
            build-max-jobs = ${toString (config.nix.maxJobs)}
            build-use-chroot = ${if config.nix.useChroot then "true" else "false"}
            build-chroot-dirs = /dev /dev/pts /proc /bin $(echo $extraPaths)
            $extraOptions
            END
          '';
      target = "nix.conf"; # will be symlinked from /nix/etc/nix/nix.conf in activate-configuration.sh.
    }

    { # Script executed when the shell starts as a non-login shell (user version).
      source = ./skel/bashrc;
      target = "skel/.bashrc";      
    }    

    { # SSH configuration.  Slight duplication of the sshd_config
      # generation in the sshd service.
      source = pkgs.writeText "ssh_config" ''
        ${if config.services.sshd.forwardX11 then ''
          ForwardX11 yes
          XAuthLocation ${pkgs.xorg.xauth}/bin/xauth
        '' else ''
          ForwardX11 no
        ''}
      '';
      target = "ssh/ssh_config";
    }
  ]

  # Configuration for ssmtp.
  ++ optional config.networking.defaultMailServer.directDelivery { 
    source = let cfg = config.networking.defaultMailServer; in pkgs.writeText "ssmtp.conf" ''
      MailHub=${cfg.hostName}
      FromLineOverride=YES
      ${if cfg.domain != "" then "rewriteDomain=${cfg.domain}" else ""}
      UseTLS=${if cfg.useTLS then "YES" else "NO"}
      UseSTARTTLS=${if cfg.useSTARTTLS then "YES" else "NO"}
      #Debug=YES
    '';
    target = "ssmtp/ssmtp.conf";
  }
    
  # Configuration file for fontconfig used to locate
  # (X11) client-rendered fonts.
  ++ optional config.fonts.enableFontConfig {
    source = pkgs.makeFontsConf {
      fontDirectories = import ../system/fonts.nix {inherit pkgs config;};
    };
    target = "fonts/fonts.conf";
  }

  # LDAP configuration.
  ++ optional config.users.ldap.enable {
    source = import ./ldap.conf.nix {
      inherit (pkgs) writeText;
      inherit config;
    };
    target = "ldap.conf";
  }
    
  # "sudo" configuration.
  ++ optional config.security.sudo.enable {
    source = pkgs.runCommand "sudoers"
      { src = pkgs.writeText "sudoers-in" (config.security.sudo.configFile);
      }
      # Make sure that the sudoers file is syntactically valid.
      # (currently disabled - NIXOS-66)
      #"${pkgs.sudo}/sbin/visudo -f $src -c && cp $src $out";
      "cp $src $out";
    target = "sudoers";
    mode = "0440";
  }
    
  # A bunch of PAM configuration files for various programs.
  ++ (map
    (program:
      let isLDAPEnabled = config.users.ldap.enable; in
      { source = pkgs.substituteAll {
          src = ./pam.d + ("/" + program);
          inherit (pkgs) pam_unix2 pam_console;
          pam_ldap =
            if isLDAPEnabled
            then pkgs.pam_ldap
            else "/no-such-path";
          inherit (pkgs.xorg) xauth;
          inherit pamConsoleHandlers;
          isLDAPEnabled = if isLDAPEnabled then "" else "#";
        };
        target = "pam.d/" + program;
      }
    )
    [
      "atd"
      "login"
      "slim"
      "su"
      "sudo"
      "other"
      "passwd"
      "shadow"
      "sshd"
      "lshd"
      "useradd"
      "chsh"
      "xlock"
      "kde"
      "cups"
      "common"
      "common-console" # shared stuff for interactive local sessions
    ]
  )

  # List of machines for distributed Nix builds in the format expected
  # by build-remote.pl.
  ++ optional config.nix.distributedBuilds {
    source = pkgs.writeText "nix.machines"
      (pkgs.lib.concatStrings (map (machine:
        "${machine.sshUser}@${machine.hostName} ${machine.system} ${machine.sshKey} ${toString machine.maxJobs}\n"
      ) config.nix.buildMachines));
    target = "nix.machines";
  }
    
  # unixODBC drivers (this solution is not perfect.. Because the user has to
  # ask the admin to add a driver.. but it's an easy solution which works)
  ++ (let inis = config.environment.unixODBCDrivers pkgs;
      in optional (inis != [] ) {
        source = pkgs.writeText "odbcinst.ini" (pkgs.lib.concatStringsSep "\n" inis);
        target = "odbcinst.ini";
      })

  # Additional /etc files declared by Upstart jobs.
  ++ extraEtc;
}
