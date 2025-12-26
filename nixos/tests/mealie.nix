{ pkgs, ... }:

{
  name = "mealie";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      litchipi
      anoa
    ];
  };

  nodes =
    let
      sqlite = {
        services.mealie = {
          enable = true;
          port = 9001;
          settings.ALLOW_SIGNUP = "true";
        };
      };
      postgres = {
        imports = [ sqlite ];
        services.mealie.database.createLocally = true;
      };
    in
    {
      inherit sqlite postgres;
    };

  testScript = ''
    import json
    import urllib.parse

    def api_get(node, path, qry={}, **headers):
      url = f"http://localhost:9001/api{path}"
      if len(qry) > 0:
        url += "?" + "&".join([f"{k}={urllib.parse.quote(v)}" for k, v in qry.items()])

      headers = " ".join([f"-H '{k}: {str(v)}'" for k, v in headers.items()])

      got = node.succeed(f"curl -s -X GET {headers} --fail {url}")
      print(f"* GET {path}\n{got}")
      return json.loads(got)

    def api_post(node, path, method="POST", urlencode=False, body={}, qry={}, **headers):
      url = f"http://localhost:9001/api{path}"
      if len(qry) > 0:
        url += "?" + "&".join([f"{k}={urllib.parse.quote(v)}" for k, v in qry.items()])

      if urlencode:
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        print("BODY", body)
        body = "&".join([f"{k}={urllib.parse.quote(str(v))}" for k, v in body.items()])
      else:
        headers["Content-Type"] = "application/json"
        body = json.dumps(body)

      headers["Accept"] = "application/json"
      headers = " ".join([f"-H '{k}: {str(v)}'" for k, v in headers.items()])

      got = node.succeed(f"curl -v --fail -X {method} {url} {headers} -d '{body}'")
      print(f"* POST {path}\n{got}")
      return json.loads(got)

    def test_mealie(node):
      node.wait_for_unit("mealie.service")
      node.wait_for_open_port(9001)
      node.succeed("curl --fail http://localhost:9001")

      got = api_get(node, "/app/about")
      assert got["version"] == "v${pkgs.mealie.version}"

      new_user = dict(
        email=node.name + ".nomail@no.mail",
        username="noname-" + node.name,
        fullName="No Name" + node.name,
        password="SuperSecure" + node.name,
        passwordConfirm="SuperSecure" + node.name,
        group="mygroup" + node.name,
      )
      got = api_post(node, "/users/register", body=new_user)
      got = api_post(node, "/auth/token", urlencode=True, body={
        "username": new_user["username"],
        "password": new_user["password"],
        "remember_me": False,
      })
      assert "access_token" in got
      token = "Bearer " + got["access_token"]

      got = api_get(node, "/recipes", authorization=token)
      assert got["total"] == 0

      slug = api_post(node, "/recipes", body={"name": "TestRecipe"}, authorization=token)
      recipe = { "description": "Test recipe" }
      got = api_post(node, f"/recipes/{slug}", body=recipe, method="PATCH", authorization=token)
      got = api_get(node, "/recipes", authorization=token)
      assert got["total"] > 0
      assert got["items"][0]["description"] == recipe["description"]

    postgres.start()
    test_mealie(postgres)
    postgres.send_monitor_command("quit")
    postgres.wait_for_shutdown()

    sqlite.start()
    test_mealie(sqlite)
    sqlite.send_monitor_command("quit")
    sqlite.wait_for_shutdown()
  '';
}
