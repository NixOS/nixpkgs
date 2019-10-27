import ../make-test.nix ({pkgs, ...}: {
  name = "kerberos_server-heimdal";
  machine = { config, libs, pkgs, ...}:
  { services.kerberos_server =
    { enable = true;
      realms = {
        "FOO.BAR".acl = [{principal = "admin"; access = ["add" "cpw"];}];
      };
    };
    krb5 = {
      enable = true;
      kerberos = pkgs.heimdalFull;
      libdefaults = {
        default_realm = "FOO.BAR";
      };
      realms = {
        "FOO.BAR" = {
          admin_server = "machine";
          kdc = "machine";
        };
      };
    };
  };

  testScript = ''
    $machine->start;

    $machine->succeed(
      "kadmin -l init --realm-max-ticket-life='8 day' \\
       --realm-max-renewable-life='10 day' FOO.BAR"
    );

    $machine->succeed("systemctl restart kadmind.service kdc.service");
    $machine->waitForUnit("kadmind.service");
    $machine->waitForUnit("kdc.service");
    $machine->waitForUnit("kpasswdd.service");

    $machine->succeed(
      "kadmin -l add --password=admin_pw --use-defaults admin"
    );
    $machine->succeed(
      "kadmin -l ext_keytab --keytab=admin.keytab admin"
    );
    $machine->succeed(
      "kadmin -p admin -K admin.keytab add --password=alice_pw --use-defaults \\
       alice"
    );
    $machine->succeed(
      "kadmin -l ext_keytab --keytab=alice.keytab alice"
    );
    $machine->succeed("kinit -kt alice.keytab alice");
  '';
})
