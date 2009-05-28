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

      # !!! This should be moved outside of /etc/default.nix.
      shellInit = mkOption {
        default = "";
        example = ''export PATH=/godi/bin/:$PATH'';
        description = "
          Script used to initialized user shell environments.
        ";
        merge = pkgs.lib.mergeStringOption;
      };
    };
  };
in

###### implementation
let
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

  ]

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
          syncSambaPasswords = if config.services.samba.syncPasswordsByPam
            then "password   optional     ${pkgs.samba}/lib/security/pam_smbpass.so nullok use_authtok try_first_pass"
            else "# change samba configuration options to make passwd sync the samba auth database as well here..";
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
      "useradd"
      "chsh"
      "xlock"
      "samba"
      "cups"
      "ftp"
      "ejabberd"
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
    
  ;
in

let
  inherit (pkgs.stringsWithDeps) noDepEntry fullDepEntry packEntry;

  copyScript = {source, target, mode ? "644", own ? "root.root"}:
    assert target != "nixos";
    ''
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
    # ../system/system-options.nix

    # config.system.activationScripts
    # ../system/activate-configuration.nix
  ];

  system = {
    build = {
      etc = makeEtc;
    };

    activationScripts = {
      etc = fullDepEntry ''
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
        "systemConfig"
        "defaultPath" # path to cp, chmod, chown
        "stdio"
      ];
    };
  };
}
