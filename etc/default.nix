# produce a script to generate /etc
{config, pkgs, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption;

  option = {
    environment = {
      etc = mkOption {
        default = [];
        example = [
          { source = "/nix/store/.../etc/dir/file.conf.example";
            target = "dir/file.conf";
            mode = "0440";
          }
        ];
        description = "
          List of files that have to be linked in /etc.
        ";
      };
    };
  };
in

###### implementation
let
  nixEnvVars = config.nix.envVars;
  modulesTree = config.system.modulesTree;
  nssModulesPath = config.system.nssModules.path;
  wrapperDir = config.system.wrapperDir;
  systemPath = config.system.path;

  optional = pkgs.lib.optional;


  # !!! ugh, these files shouldn't be created here.


  pamConsoleHandlers = pkgs.writeText "console.handlers" ''
    console consoledevs /dev/tty[0-9][0-9]* :[0-9]\.[0-9] :[0-9]
    ${pkgs.pam_console}/sbin/pam_console_apply lock logfail wait -t tty -s -c ${pamConsolePerms}
    ${pkgs.pam_console}/sbin/pam_console_apply unlock logfail wait -r -t tty -s -c ${pamConsolePerms}
  '';

  pamConsolePerms = ./security/console.perms;

  # These should be moved into the corresponding configuration files.
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

    { # Configuration for passwd and friends (e.g., hash algorithm
      # for /etc/passwd).
      source = ./default/passwd;
      target = "default/passwd";
    }

    { # Configuration for useradd.
      source = pkgs.substituteAll {
        src = ./default/useradd;
        defaultShell = config.system.shell;
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
      source = pkgs.writeText "nix.conf" ''
        # WARNING: this file is generated.
        build-users-group = nixbld
        build-max-jobs = ${toString (config.nix.maxJobs)}
        build-use-chroot = ${if config.nix.useChroot then "true" else "false"}
        build-chroot-dirs = /dev /dev/pts /proc /bin
        ${config.nix.extraOptions}
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

  # LDAP configuration.
  ++ optional config.users.ldap.enable {
    source = import ./ldap.conf.nix {
      inherit (pkgs) writeText;
      inherit config;
    };
    target = "ldap.conf";
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
      "login"
      "su"
      "other"
      "passwd"
      "shadow"
      "sshd"
      "lshd"
      "lsh-pam-checkpw"
      "useradd"
      "chsh"
      "xlock"
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
  ;
in

let
  inherit (pkgs.stringsWithDeps) noDepEntry FullDepEntry PackEntry;

  activateLib = config.system.activationScripts.lib;

  copyScript = {source, target, mode ? "644", own ? "root.root"}:
    assert target != "nixos"; ''
    source="${source}"
    target="/etc/${target}"
    mkdir -p $(dirname "$target")
    test -e "$target" && rm -f "$target"
    cp "$source" "$target"
    chown ${own} "$target"
    chmod ${mode} "$target"
  '';

  makeEtc = import ../helpers/make-etc.nix {
    inherit (pkgs) stdenv;
    configFiles = configFiles ++ config.environment.etc;
  };
in

{
  require = [
    option

    # config.system.build
    (import ../system/system-options.nix)

    # config.system.activationScripts
    (import ../system/activate-configuration.nix)
  ];

  system = {
    build = {
      etc = makeEtc;
    };

    activationScripts = {
      etc = FullDepEntry ''
        # Set up the statically computed bits of /etc.
        staticEtc=/etc/static
        rm -f $staticEtc
        ln -s ${makeEtc}/etc $staticEtc
        for i in $(cd $staticEtc && find * -type l); do
            mkdir -p /etc/$(dirname $i)
            rm -f /etc/$i
            if test -e "$staticEtc/$i.mode"; then
                # Create a regular file in /etc.
                cp $staticEtc/$i /etc/$i
                chown 0.0 /etc/$i
                chmod "$(cat "$staticEtc/$i.mode")" /etc/$i
            else
                # Create a symlink in /etc.
                ln -s $staticEtc/$i /etc/$i
            fi
        done

        # Remove dangling symlinks that point to /etc/static.  These are
        # configuration files that existed in a previous configuration but not
        # in the current one.  For efficiency, don't look under /etc/nixos
        # (where all the NixOS sources live).
        for i in $(find /etc/ \( -path /etc/nixos -prune \) -o -type l); do
            target=$(readlink "$i")
            if test "''${target:0:''${#staticEtc}}" = "$staticEtc" -a ! -e "$i"; then
                rm -f "$i"
            fi
        done
      '' [
        activateLib.systemConfig
        activateLib.defaultPath # path to cp, chmod, chown
        activateLib.stdio
      ];
    };
  };
}
