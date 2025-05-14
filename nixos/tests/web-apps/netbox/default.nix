let
  ldapDomain = "example.org";
  ldapSuffix = "dc=example,dc=org";

  ldapRootUser = "admin";
  ldapRootPassword = "foobar";

  testUser = "alice";
  testPassword = "verySecure";
  testGroup = "netbox-users";
in
import ../../make-test-python.nix (
  {
    lib,
    pkgs,
    netbox,
    ...
  }:
  {
    name = "netbox";

    meta = with lib.maintainers; {
      maintainers = [
        minijackson
      ];
    };

    skipTypeCheck = true;

    nodes.machine =
      { config, ... }:
      {
        virtualisation.memorySize = 2048;
        services.netbox = {
          enable = true;
          package = netbox;
          secretKeyFile = pkgs.writeText "secret" ''
            abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
          '';

          enableLdap = true;
          ldapConfigPath = pkgs.writeText "ldap_config.py" ''
            import ldap
            from django_auth_ldap.config import LDAPSearch, PosixGroupType

            AUTH_LDAP_SERVER_URI = "ldap://localhost/"

            AUTH_LDAP_USER_SEARCH = LDAPSearch(
                "ou=accounts,ou=posix,${ldapSuffix}",
                ldap.SCOPE_SUBTREE,
                "(uid=%(user)s)",
            )

            AUTH_LDAP_GROUP_SEARCH = LDAPSearch(
                "ou=groups,ou=posix,${ldapSuffix}",
                ldap.SCOPE_SUBTREE,
                "(objectClass=posixGroup)",
            )
            AUTH_LDAP_GROUP_TYPE = PosixGroupType()

            # Mirror LDAP group assignments.
            AUTH_LDAP_MIRROR_GROUPS = True

            # For more granular permissions, we can map LDAP groups to Django groups.
            AUTH_LDAP_FIND_GROUP_PERMS = True
          '';
        };

        services.nginx = {
          enable = true;

          recommendedProxySettings = true;

          virtualHosts.netbox = {
            default = true;
            locations."/".proxyPass = "http://localhost:${toString config.services.netbox.port}";
            locations."/static/".alias = "/var/lib/netbox/static/";
          };
        };

        # Adapted from the sssd-ldap NixOS test
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
                  objectClass = [
                    "olcDatabaseConfig"
                    "olcMdbConfig"
                  ];
                  olcDatabase = "{1}mdb";
                  olcDbDirectory = "/var/lib/openldap/db";
                  olcSuffix = ldapSuffix;
                  olcRootDN = "cn=${ldapRootUser},${ldapSuffix}";
                  olcRootPW = ldapRootPassword;
                };
              };
            };
          };
          declarativeContents = {
            ${ldapSuffix} = ''
              dn: ${ldapSuffix}
              objectClass: top
              objectClass: dcObject
              objectClass: organization
              o: ${ldapDomain}

              dn: ou=posix,${ldapSuffix}
              objectClass: top
              objectClass: organizationalUnit

              dn: ou=accounts,ou=posix,${ldapSuffix}
              objectClass: top
              objectClass: organizationalUnit

              dn: uid=${testUser},ou=accounts,ou=posix,${ldapSuffix}
              objectClass: person
              objectClass: posixAccount
              userPassword: ${testPassword}
              homeDirectory: /home/${testUser}
              uidNumber: 1234
              gidNumber: 1234
              cn: ""
              sn: ""

              dn: ou=groups,ou=posix,${ldapSuffix}
              objectClass: top
              objectClass: organizationalUnit

              dn: cn=${testGroup},ou=groups,ou=posix,${ldapSuffix}
              objectClass: posixGroup
              gidNumber: 2345
              memberUid: ${testUser}
            '';
          };
        };

        users.users.nginx.extraGroups = [ "netbox" ];

        networking.firewall.allowedTCPPorts = [ 80 ];
      };

    testScript =
      let
        changePassword = pkgs.writeText "change-password.py" ''
          from users.models import User
          u = User.objects.get(username='netbox')
          u.set_password('netbox')
          u.save()
        '';
      in
      builtins.replaceStrings
        [ "$\{changePassword}" "$\{testUser}" "$\{testPassword}" "$\{testGroup}" ]
        [ "${changePassword}" "${testUser}" "${testPassword}" "${testGroup}" ]
        (lib.readFile "${./testScript.py}");
  }
)
