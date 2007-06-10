{config, pkgs, upstartJobs, systemPath, wrapperDir, defaultShell, extraEtc}:

let 


  optional = option: file:
    if config.get option then [file] else [];


  # !!! ugh, these files shouldn't be created here.
    
    
  envConf = pkgs.writeText "environment" "
    PATH=${systemPath}/bin:${systemPath}/sbin:${pkgs.openssh}/bin
    NIX_REMOTE=daemon
  " /* ${pkgs.openssh}/bin is a hack to get remote scp to work */;


  # Don't indent this file!
  pamConsoleHandlers = pkgs.writeText "console.handlers" "
console consoledevs /dev/tty[0-9][0-9]* :[0-9]\.[0-9] :[0-9]
${pkgs.pam_console}/sbin/pam_console_apply lock logfail wait -t tty -s -c ${pamConsolePerms}
${pkgs.pam_console}/sbin/pam_console_apply unlock logfail wait -r -t tty -s -c ${pamConsolePerms}
";

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

    { # Hostname-to-IP mappings.
      source = ./hosts;
      target = "hosts";
    }

    { # Name Service Switch configuration file.  Required by the C library.
      source = ./nsswitch.conf;
      target = "nsswitch.conf";
    }

    { # Configuration file for the system logging daemon.
      source = ./syslog.conf;
      target = "syslog.conf";
    }

    { # Friendly greeting on the virtual consoles.
      source = ./issue;
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

    { # Script executed when the shell starts.
      source = pkgs.substituteAll {
        src = ./profile.sh;
        inherit systemPath wrapperDir;
        inherit (pkgs) kernel glibc;
        timeZone = config.get ["time" "timeZone"];
        defaultLocale = config.get ["i18n" "defaultLocale"];
      };
      target = "profile";
    }

    { # Configuration for readline in bash.
      source = ./inputrc;
      target = "inputrc";
    }

  ]

  # Configuration file for fontconfig used to locate
  # (X11) client-rendered fonts.
  ++ (optional ["fonts" "enableFontConfig"] { 
    source = pkgs.runCommand "fonts.conf"
      { 
        fontDirectories = import ../system/fonts.nix {inherit pkgs;};
        buildInputs = [pkgs.libxslt];
        inherit (pkgs) fontconfig;
      }
      "xsltproc --stringparam fontDirectories \"$fontDirectories\" \\
          ${./fonts/make-fonts-conf.xsl} $fontconfig/etc/fonts/fonts.conf \\
          > $out
      ";
    target = "fonts/fonts.conf";
  })

  # LDAP configuration.
  ++ (optional ["users" "ldap" "enable"] {
    source = import ./ldap.conf.nix {
      inherit (pkgs) writeText;
      inherit config;
    };
    target = "ldap.conf";
  })
    
  # A bunch of PAM configuration files for various programs.
  ++ (map
    (program:
      let isLDAPEnabled = config.get ["users" "ldap" "enable"]; in
      { source = pkgs.substituteAll {
          src = ./pam.d + ("/" + program);
          inherit (pkgs) pam_unix2 pam_console;
          pam_ldap =
            if isLDAPEnabled
            then pkgs.pam_ldap
            else "/no-such-path";
          inherit (pkgs.xorg) xauth;
          inherit envConf pamConsoleHandlers;
          isLDAPEnabled = if isLDAPEnabled then "" else "#";
        };
        target = "pam.d/" + program;
      }
    )
    [
      "login"
      "slim"
      "su"
      "other"
      "passwd"
      "shadow"
      "sshd"
      "useradd"
      "chsh"
      "common"
      "common-console" # shared stuff for interactive local sessions
    ]
  )

  # Additional /etc files declared by Upstart jobs.
  ++ extraEtc;
  
}
