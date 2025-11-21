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
  teamName = "myteam";
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

      environment.systemPackages = [ pkgs.jq ];

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
              call = "telephoneNumber";
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

    with subtest("Create and verify team via REST API"):
        import json

        # Log in and store the session cookie
        login_response = machine.succeed("""
            curl -sSfL -c cookies -X POST \
                --data-raw 'username=${testUser}&password=${testPassword}' \
                http://[::1]:80/login
        """)

        # Parse csrf token
        login_response_data = json.loads(login_response)
        csrf_token = login_response_data["csrf_token"]

        # Create the team
        machine.succeed(
          f"""curl -sSfL -b cookies -X POST -H 'Content-Type: application/json' -H 'X-CSRF-Token: {csrf_token}' -d '{{"name": "${teamName}", "email": "test@example.com", "scheduling_timezone": "Europe/Berlin", "iris_enabled": false}}' http://[::1]:80/api/v0/teams/"""
        )

        # Query the created team
        machine.succeed("""
            curl -sSfL -b cookies http://[::1]:80/api/v0/teams/${teamName} | jq -e '.name == "${teamName}"'
        """)

  '';
}
