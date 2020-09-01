import ./make-test-python.nix ({ pkgs, ... }:
  let
    dbDomain = "example.org";
    dbSuffix = "dc=example,dc=org";

    ldapRootUser = "admin";
    ldapRootPassword = "foobar";

    testUser = "alice";
  in
  {
    name = "sssd-ldap";

    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ bbigras ];
    };

    machine = { pkgs, ... }: {
      services.openldap = {
        enable = true;
        rootdn = "cn=${ldapRootUser},${dbSuffix}";
        rootpw = ldapRootPassword;
        suffix = dbSuffix;
        declarativeContents = ''
          dn: ${dbSuffix}
          objectClass: top
          objectClass: dcObject
          objectClass: organization
          o: ${dbDomain}

          dn: ou=posix,${dbSuffix}
          objectClass: top
          objectClass: organizationalUnit

          dn: ou=accounts,ou=posix,${dbSuffix}
          objectClass: top
          objectClass: organizationalUnit

          dn: uid=${testUser},ou=accounts,ou=posix,${dbSuffix}
          objectClass: person
          objectClass: posixAccount
          # userPassword: somePasswordHash
          homeDirectory: /home/${testUser}
          uidNumber: 1234
          gidNumber: 1234
          cn: ""
          sn: ""
        '';
      };

      services.sssd = {
        enable = true;
        config = ''
          [sssd]
          config_file_version = 2
          services = nss, pam, sudo
          domains = ${dbDomain}

          [domain/${dbDomain}]
          auth_provider = ldap
          id_provider = ldap
          ldap_uri = ldap://127.0.0.1:389
          ldap_search_base = ${dbSuffix}
          ldap_default_bind_dn = cn=${ldapRootUser},${dbSuffix}
          ldap_default_authtok_type = password
          ldap_default_authtok = ${ldapRootPassword}
        '';
      };
    };

    testScript = ''
      machine.start()
      machine.wait_for_unit("openldap.service")
      machine.wait_for_unit("sssd.service")
      machine.succeed("getent passwd ${testUser}")
    '';
  }
)
