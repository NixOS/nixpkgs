{pkgs, upstartJobs}:

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
      source = ./etc/hosts;
      target = "hosts";
    }

    { # Name Service Switch configuration file.  Required by the C library.
      source = ./etc/nsswitch.conf;
      target = "nsswitch.conf";
    }

    { # Configuration file for the system logging daemon.
      source = ./etc/syslog.conf;
      target = "syslog.conf";
    }

    { # Friendly greeting on the virtual consoles.
      source = ./etc/issue;
      target = "issue";
    }

    { # Configuration for pwdutils (login, passwd, useradd, etc.).
      # You cannot login without it!
      source = ./etc/login.defs;
      target = "login.defs";
    }

    { # The Upstart events defined above.
      source = upstartJobs + "/etc/event.d";
      target = "event.d";
    }

    { # Configuration for passwd and friends (e.g., hash algorithm
      # for /etc/passwd).
      source = ./etc/default/passwd;
      target = "default/passwd";
    }

  ]

  # A bunch of PAM configuration files for various programs.
  ++ (map
    (program:
      { source = pkgs.substituteAll {
          src = ./etc/pam.d + ("/" + program);
          inherit (pkgs) pam_unix2;
        };
        target = "pam.d/" + program;
      }
    )
    [
      "login"
      "sshd"
      "passwd"
      "useradd"
      "other"
    ]
  );
}