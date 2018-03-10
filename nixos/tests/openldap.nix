import ./make-test.nix {
  name = "dovecot";

  machine = { pkgs, ... }: {
    services.openldap = {
      enable = true;
      extraConfig = ''
        include ${pkgs.openldap}/etc/schema/core.schema
        include ${pkgs.openldap}/etc/schema/cosine.schema
        include ${pkgs.openldap}/etc/schema/inetorgperson.schema
        include ${pkgs.openldap}/etc/schema/nis.schema
        database bdb
        suffix dc=example
        directory /var/db/openldap
        rootdn cn=root,dc=example
        rootpw notapassword
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
    $machine->succeed('systemctl status openldap.service');
    $machine->waitForUnit('openldap.service');
    $machine->succeed('ldapsearch -LLL -D "cn=root,dc=example" -w notapassword -b "dc=example"');
  '';
}
