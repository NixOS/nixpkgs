let
  ldapDomain = "example.org";
  ldapSuffix = "dc=example,dc=org";

  ldapRootUser = "admin";
  ldapRootPassword = "foobar";

  testUser = "alice";
  testPassword = "verySecure";
  testGroup = "netbox-users";
in import ../make-test-python.nix ({ lib, pkgs, netbox, ... }: {
  name = "netbox";

  meta = with lib.maintainers; {
    maintainers = [ minijackson n0emis ];
  };

  nodes.machine = { config, ... }: {
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
              objectClass = [ "olcDatabaseConfig" "olcMdbConfig" ];
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

  testScript = let
    changePassword = pkgs.writeText "change-password.py" ''
      from django.contrib.auth.models import User
      u = User.objects.get(username='netbox')
      u.set_password('netbox')
      u.save()
    '';
  in ''
    from typing import Any, Dict
    import json

    start_all()
    machine.wait_for_unit("netbox.target")
    machine.wait_until_succeeds("journalctl --since -1m --unit netbox --grep Listening")

    with subtest("Home screen loads"):
        machine.succeed(
            "curl -sSfL http://[::1]:8001 | grep '<title>Home | NetBox</title>'"
        )

    with subtest("Staticfiles are generated"):
        machine.succeed("test -e /var/lib/netbox/static/netbox.js")

    with subtest("Superuser can be created"):
        machine.succeed(
            "netbox-manage createsuperuser --noinput --username netbox --email netbox@example.com"
        )
        # Django doesn't have a "clean" way of inputting the password from the command line
        machine.succeed("cat '${changePassword}' | netbox-manage shell")

    machine.wait_for_unit("network.target")

    with subtest("Home screen loads from nginx"):
        machine.succeed(
            "curl -sSfL http://localhost | grep '<title>Home | NetBox</title>'"
        )

    with subtest("Staticfiles can be fetched"):
        machine.succeed("curl -sSfL http://localhost/static/netbox.js")
        machine.succeed("curl -sSfL http://localhost/static/docs/")

    with subtest("Can interact with API"):
        json.loads(
            machine.succeed("curl -sSfL -H 'Accept: application/json' 'http://localhost/api/'")
        )

    def login(username: str, password: str):
        encoded_data = json.dumps({"username": username, "password": password})
        uri = "/users/tokens/provision/"
        result = json.loads(
            machine.succeed(
                "curl -sSfL "
                "-X POST "
                "-H 'Accept: application/json' "
                "-H 'Content-Type: application/json' "
                f"'http://localhost/api{uri}' "
                f"--data '{encoded_data}'"
            )
        )
        return result["key"]

    with subtest("Can login"):
        auth_token = login("netbox", "netbox")

    def get(uri: str):
        return json.loads(
            machine.succeed(
                "curl -sSfL "
                "-H 'Accept: application/json' "
                f"-H 'Authorization: Token {auth_token}' "
                f"'http://localhost/api{uri}'"
            )
        )

    def delete(uri: str):
        return machine.succeed(
            "curl -sSfL "
            f"-X DELETE "
            "-H 'Accept: application/json' "
            f"-H 'Authorization: Token {auth_token}' "
            f"'http://localhost/api{uri}'"
        )


    def data_request(uri: str, method: str, data: Dict[str, Any]):
        encoded_data = json.dumps(data)
        return json.loads(
            machine.succeed(
                "curl -sSfL "
                f"-X {method} "
                "-H 'Accept: application/json' "
                "-H 'Content-Type: application/json' "
                f"-H 'Authorization: Token {auth_token}' "
                f"'http://localhost/api{uri}' "
                f"--data '{encoded_data}'"
            )
        )

    def post(uri: str, data: Dict[str, Any]):
      return data_request(uri, "POST", data)

    def patch(uri: str, data: Dict[str, Any]):
      return data_request(uri, "PATCH", data)

    with subtest("Can create objects"):
        result = post("/dcim/sites/", {"name": "Test site", "slug": "test-site"})
        site_id = result["id"]

        # Example from:
        # http://netbox.extra.cea.fr/static/docs/integrations/rest-api/#creating-a-new-object
        post("/ipam/prefixes/", {"prefix": "192.0.2.0/24", "site": site_id})

        result = post(
            "/dcim/manufacturers/",
            {"name": "Test manufacturer", "slug": "test-manufacturer"}
        )
        manufacturer_id = result["id"]

        # Had an issue with device-types before NetBox 3.4.0
        result = post(
            "/dcim/device-types/",
            {
                "model": "Test device type",
                "manufacturer": manufacturer_id,
                "slug": "test-device-type",
            },
        )
        device_type_id = result["id"]

    with subtest("Can list objects"):
        result = get("/dcim/sites/")

        assert result["count"] == 1
        assert result["results"][0]["id"] == site_id
        assert result["results"][0]["name"] == "Test site"
        assert result["results"][0]["description"] == ""

        result = get("/dcim/device-types/")
        assert result["count"] == 1
        assert result["results"][0]["id"] == device_type_id
        assert result["results"][0]["model"] == "Test device type"

    with subtest("Can update objects"):
        new_description = "Test site description"
        patch(f"/dcim/sites/{site_id}/", {"description": new_description})
        result = get(f"/dcim/sites/{site_id}/")
        assert result["description"] == new_description

    with subtest("Can delete objects"):
        # Delete a device-type since no object depends on it
        delete(f"/dcim/device-types/{device_type_id}/")

        result = get("/dcim/device-types/")
        assert result["count"] == 0

    with subtest("Can use the GraphQL API"):
        encoded_data = json.dumps({
            "query": "query { prefix_list { prefix, site { id, description } } }",
        })
        result = json.loads(
            machine.succeed(
                "curl -sSfL "
                "-H 'Accept: application/json' "
                "-H 'Content-Type: application/json' "
                f"-H 'Authorization: Token {auth_token}' "
                "'http://localhost/graphql/' "
                f"--data '{encoded_data}'"
            )
        )

        assert len(result["data"]["prefix_list"]) == 1
        assert result["data"]["prefix_list"][0]["prefix"] == "192.0.2.0/24"
        assert result["data"]["prefix_list"][0]["site"]["id"] == str(site_id)
        assert result["data"]["prefix_list"][0]["site"]["description"] == new_description

    with subtest("Can login with LDAP"):
        machine.wait_for_unit("openldap.service")
        login("alice", "${testPassword}")

    with subtest("Can associate LDAP groups"):
        result = get("/users/users/?username=${testUser}")

        assert result["count"] == 1
        assert any(group["name"] == "${testGroup}" for group in result["results"][0]["groups"])
  '';
})
