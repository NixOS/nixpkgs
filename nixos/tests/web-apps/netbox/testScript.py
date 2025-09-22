from typing import Any, Dict
import json

start_all()
machine.wait_for_unit("netbox.target")
machine.wait_until_succeeds("journalctl --since -1m --unit netbox --grep Listening")

test_objects = {
    "sites": {
        "test-site": {
            "name": "Test site",
            "slug": "test-site"
        },
        "test-site-two": {
            "name": "Test site 2",
            "slug": "test-site-second-edition"
        }
    },
    "prefixes": {
        "v4-with-updated-desc": {
            "prefix": "192.0.2.0/24",
            "class_type": "Prefix",
            "family": { "label": "IPv4" },
            "scope": {
                "__typename": "SiteType",
                "id": "1",
                "description": "Test site description"
            }
        },
        "v6-cidr-32": {
            "prefix": "2001:db8::/32",
            "class_type": "Prefix",
            "family": { "label": "IPv6" },
            "scope": {
                "__typename": "SiteType",
                "id": "1",
                "description": "Test site description"
            }
        },
        "v6-cidr-48": {
            "prefix": "2001:db8:c0fe::/48",
            "class_type": "Prefix",
            "family": { "label": "IPv6" },
            "scope": {
                "__typename": "SiteType",
                "id": "1",
                "description": "Test site description"
            }
        }
    }
}

def compare(a: str, b: str):
    differences = [(x - y) for (x,y) in list(zip(
        list(map(int, a.split('.'))),
        list(map(int, b.split('.')))
    ))]
    for d in differences:
        if d != 0:
            return d
    return 0

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

# Retrieve netbox version
netbox_version = get("/status/")["netbox-version"]

with subtest("Can create objects"):
    result = post("/dcim/sites/", {"name": "Test site", "slug": "test-site"})
    site_id = result["id"]


    for prefix in test_objects["prefixes"].values():
        if compare(netbox_version, '4.2.0') >= 0:
            post("/ipam/prefixes/", {
                "prefix": prefix["prefix"],
                "scope_id": site_id,
                "scope_type": "dcim." + prefix["scope"]["__typename"].replace("Type", "").lower()
            })
            prefix["scope"]["id"] = str(site_id)
        else:
            post("/ipam/prefixes/", {
                "prefix": prefix["prefix"],
                "site": str(site_id),
            })

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

def request_graphql(query: str):
    return machine.succeed(
        "curl -sSfL "
        "-H 'Accept: application/json' "
        "-H 'Content-Type: application/json' "
        f"-H 'Authorization: Token {auth_token}' "
        "'http://localhost/graphql/' "
        f"--data '{json.dumps({"query": query})}'"
    )


if compare(netbox_version, '4.2.0') >= 0:
    with subtest("Can use the GraphQL API (NetBox 4.2.0+)"):
        graphql_query = '''query {
          prefix_list {
            prefix
            class_type
            family {
              label
            }
            scope {
              __typename
              ... on SiteType {
                id
                description
              }
            }
          }
        }
        '''

        answer = request_graphql(graphql_query)
        result = json.loads(answer)
        assert len(result["data"]["prefix_list"]) == 3
        assert test_objects["prefixes"]["v4-with-updated-desc"] in result["data"]["prefix_list"]
        assert test_objects["prefixes"]["v6-cidr-32"] in result["data"]["prefix_list"]
        assert test_objects["prefixes"]["v6-cidr-48"] in result["data"]["prefix_list"]

if compare(netbox_version, '4.2.0') < 0:
    with subtest("Can use the GraphQL API (Netbox <= 4.2.0)"):
        answer = request_graphql('''query {
          prefix_list {
            prefix
            site {
              id
            }
          }
        }
        ''')
        result = json.loads(answer)
        print(result["data"]["prefix_list"][0])
        assert result["data"]["prefix_list"][0]["prefix"] == test_objects["prefixes"]["v4-with-updated-desc"]["prefix"]
        assert int(result["data"]["prefix_list"][0]["site"]["id"]) == int(test_objects["prefixes"]["v4-with-updated-desc"]["scope"]["id"])

with subtest("Can login with LDAP"):
    machine.wait_for_unit("openldap.service")
    login("alice", "${testPassword}")

with subtest("Can associate LDAP groups"):
    result = get("/users/users/?username=${testUser}")

    assert result["count"] == 1
    assert any(group["name"] == "${testGroup}" for group in result["results"][0]["groups"])
