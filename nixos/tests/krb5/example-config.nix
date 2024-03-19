# Verifies that the configuration suggested in (non-deprecated) example values
# will result in the expected output.

import ../make-test-python.nix ({ pkgs, ...} : {
  name = "krb5-with-example-config";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ eqyiel dblsaiko ];
  };

  nodes.machine =
    { pkgs, ... }: {
      security.krb5 = {
        enable = true;
        package = pkgs.krb5;
        settings = {
          includedir = [
            "/etc/krb5.conf.d"
          ];
          include = [
            "/etc/krb5-extra.conf"
          ];
          libdefaults = {
            default_realm = "ATHENA.MIT.EDU";
          };
          realms = {
            "ATHENA.MIT.EDU" = {
              admin_server = "athena.mit.edu";
              kdc = [
                "athena01.mit.edu"
                "athena02.mit.edu"
              ];
            };
          };
          domain_realm = {
            "example.com" = "EXAMPLE.COM";
            ".example.com" = "EXAMPLE.COM";
          };
          capaths = {
            "ATHENA.MIT.EDU" = {
              "EXAMPLE.COM" = ".";
            };
            "EXAMPLE.COM" = {
              "ATHENA.MIT.EDU" = ".";
            };
          };
          appdefaults = {
            pam = {
              debug = false;
              ticket_lifetime = 36000;
              renew_lifetime = 36000;
              max_timeout = 30;
              timeout_shift = 2;
              initial_timeout = 1;
            };
          };
          plugins.ccselect.disable = "k5identity";
          logging = {
            kdc = "SYSLOG:NOTICE";
            admin_server = "SYSLOG:NOTICE";
            default = "SYSLOG:NOTICE";
          };
        };
      };
    };

  testScript =
    let snapshot = pkgs.writeText "krb5-with-example-config.conf" ''
      [appdefaults]
        pam = {
          debug = false
          initial_timeout = 1
          max_timeout = 30
          renew_lifetime = 36000
          ticket_lifetime = 36000
          timeout_shift = 2
        }

      [capaths]
        ATHENA.MIT.EDU = {
          EXAMPLE.COM = .
        }
        EXAMPLE.COM = {
          ATHENA.MIT.EDU = .
        }

      [domain_realm]
        .example.com = EXAMPLE.COM
        example.com = EXAMPLE.COM

      [libdefaults]
        default_realm = ATHENA.MIT.EDU

      [logging]
        admin_server = SYSLOG:NOTICE
        default = SYSLOG:NOTICE
        kdc = SYSLOG:NOTICE

      [plugins]
        ccselect = {
          disable = k5identity
        }

      [realms]
        ATHENA.MIT.EDU = {
          admin_server = athena.mit.edu
          kdc = athena01.mit.edu
          kdc = athena02.mit.edu
        }

      include /etc/krb5-extra.conf
      includedir /etc/krb5.conf.d
    '';
  in ''
    machine.succeed(
        "diff /etc/krb5.conf ${snapshot}"
    )
  '';
})
