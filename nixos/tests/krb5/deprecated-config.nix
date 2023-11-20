# Verifies that the configuration suggested in deprecated example values
# will result in the expected output.

import ../make-test-python.nix ({ pkgs, ...} : {
  name = "krb5-with-deprecated-config";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ eqyiel ];
  };

  nodes.machine =
    { ... }: {
      krb5 = {
        enable = true;
        defaultRealm = "ATHENA.MIT.EDU";
        domainRealm = "athena.mit.edu";
        kdc = "kerberos.mit.edu";
        kerberosAdminServer = "kerberos.mit.edu";
      };
    };

  testScript =
    let snapshot = pkgs.writeText "krb5-with-deprecated-config.conf" ''
      [libdefaults]
        default_realm = ATHENA.MIT.EDU

      [realms]
        ATHENA.MIT.EDU = {
          admin_server = kerberos.mit.edu
          kdc = kerberos.mit.edu
        }

      [domain_realm]
        .athena.mit.edu = ATHENA.MIT.EDU
        athena.mit.edu = ATHENA.MIT.EDU

      [capaths]


      [appdefaults]


      [plugins]

    '';
  in ''
    machine.succeed(
        "diff /etc/krb5.conf ${snapshot}"
    )
  '';
})
