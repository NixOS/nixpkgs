{
  lib,
  pkgs,
  config,
  ...
}:
let
  ldapDomain = "example.org";
  ldapSuffix = "dc=example,dc=org";

  ldapRootUser = "root";
  ldapRootPassword = "foobar23";

  testUser = "myuser";
  testPassword = "foobar23";
in
{
  name = "oncall";
  meta.maintainers = with lib.maintainers; [ onny ];

  nodes = {
    machine = {
      virtualisation.memorySize = 2048;

      environment.etc."oncall-secrets.yml".text = ''
        auth:
          ldap_bind_password: "${ldapRootPassword}"
      '';

      services.oncall = {
        enable = true;
        settings = {
          auth = {
            module = "oncall.auth.modules.ldap_import";
            ldap_url = "ldap://localhost";
            ldap_user_suffix = "";
            ldap_bind_user = "cn=${ldapRootUser},${ldapSuffix}";
            ldap_base_dn = "ou=accounts,${ldapSuffix}";
            ldap_search_filter = "(uid=%s)";
            import_user = true;
            attrs = {
              username = "uid";
              full_name = "cn";
              email = "mail";
              mobile = "telephoneNumber";
              sms = "mobile";
            };
          };
        };
        secretFile = "/etc/oncall-secrets.yml";
      };

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

            dn: ou=accounts,${ldapSuffix}
            objectClass: top
            objectClass: organizationalUnit

            dn: uid=${testUser},ou=accounts,${ldapSuffix}
            objectClass: top
            objectClass: inetOrgPerson
            uid: ${testUser}
            userPassword: ${testPassword}
            cn: Test User
            sn: User
            mail: test@example.org
            telephoneNumber: 012345678910
            mobile: 012345678910
          '';
        };
      };
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("uwsgi.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_file("/run/uwsgi/oncall.sock")
    machine.wait_for_unit("oncall-setup-database.service")

    with subtest("Home screen loads"):
        machine.succeed(
            "curl -sSfL http://[::1]:80 | grep '<title>Oncall</title>'"
        )

    with subtest("Staticfiles can be fetched"):
        machine.wait_until_succeeds(
          "curl -sSfL http://[::1]:80/static/bundles/libs.js"
        )

    with subtest("Staticfiles are generated"):
        machine.succeed(
          "test -e /var/lib/oncall/static/bundles/libs.js"
        )

    with subtest("Authenticate"):
        machine.succeed(
          "curl 'http://[::1]:80/login' -X POST --data-raw 'username=${testUser}&password=${testPassword}'"
        )
  '';
}
