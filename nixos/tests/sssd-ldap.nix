let
  dbDomain = "example.org";
  dbSuffix = "dc=example,dc=org";

  ldapRootUser = "admin";
  ldapRootPassword = "foobar";

  testUser = "alice";
in import ./make-test-python.nix ({pkgs, ...}: {
  name = "sssd-ldap";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ bbigras ];
  };

  nodes.machine = { pkgs, ... }: {
    services.openldap = {
      enable = true;
      settings = {
        children = {
          "cn=schema".includes = [
            "${pkgs.openldap}/etc/schema/core.ldif"
            "${pkgs.openldap}/etc/schema/cosine.ldif"
            "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
            "${pkgs.openldap}/etc/schema/nis.ldif"
          ];
          "olcDatabase={1}mdb" = {
            attrs = {
              objectClass = [ "olcDatabaseConfig" "olcMdbConfig" ];
              olcDatabase = "{1}mdb";
              olcDbDirectory = "/var/lib/openldap/db";
              olcSuffix = dbSuffix;
              olcRootDN = "cn=${ldapRootUser},${dbSuffix}";
              olcRootPW = ldapRootPassword;
            };
          };
        };
      };
      declarativeContents = {
        ${dbSuffix} = ''
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
    };

    services.sssd = {
      enable = true;
      # just for testing purposes, don't put this into the Nix store in production!
      environmentFile = "${pkgs.writeText "ldap-root" "LDAP_BIND_PW=${ldapRootPassword}"}";
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
        ldap_default_authtok = $LDAP_BIND_PW
      '';
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("openldap.service")
    machine.wait_for_unit("sssd.service")
    machine.succeed("getent passwd ${testUser}")
  '';
})
