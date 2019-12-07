import ./make-test-python.nix {
  name = "openldap";

  machine = { pkgs, ... }: {
    services.openldap = {
      enable = true;
      suffix = "dc=example";
      rootdn = "cn=root,dc=example";
      rootpw = "notapassword";
      database = "bdb";
      extraDatabaseConfig = ''
        directory /var/db/openldap
      '';
      declarativeContents = ''
        dn: dc=example
        objectClass: domain
        dc: example

        dn: ou=users,dc=example
        objectClass: organizationalUnit
        ou: users
      '';
    };
  };

  testScript = ''
    machine.wait_for_unit("openldap.service")
    machine.succeed(
        "systemctl status openldap.service",
        'ldapsearch -LLL -D "cn=root,dc=example" -w notapassword -b "dc=example"',
    )
  '';
}
