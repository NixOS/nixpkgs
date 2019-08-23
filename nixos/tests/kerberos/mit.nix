import ../make-test.nix ({pkgs, ...}: {
  name = "kerberos_server-mit";
  machine = { config, libs, pkgs, ...}:
  { services.kerberos_server =
    { enable = true;
      realms = {
        "FOO.BAR".acl = [{principal = "admin"; access = ["add" "cpw"];}];
      };
    };
    krb5 = {
      enable = true;
      kerberos = pkgs.krb5Full;
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
    users.extraUsers.alice = { isNormalUser = true; };
  };

  testScript = ''
    $machine->start;

    $machine->succeed(
      "kdb5_util create -s -r FOO.BAR -P master_key"
    );

    $machine->succeed("systemctl restart kadmind.service kdc.service");
    $machine->waitForUnit("kadmind.service");
    $machine->waitForUnit("kdc.service");

    $machine->succeed(
      "kadmin.local add_principal -pw admin_pw admin"
    );
    $machine->succeed(
      "kadmin -p admin -w admin_pw addprinc -pw alice_pw alice"
    );
    $machine->succeed("echo alice_pw | sudo -u alice kinit");
  '';
})
