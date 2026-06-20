{ pkgs, ... }:
let
  port = "7745";
in
{
  name = "homebox";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ patrickdag ];
  };
  nodes =
    let
      self = {
        simple = {
          services.homebox = {
            enable = true;
            settings.HBOX_WEB_PORT = port;
            settings.HBOX_OPTIONS_ALLOW_REGISTRATION = "true";
            settings.HBOX_LOG_LEVEL = "trace";
          };
        };

        postgres = {
          imports = [ self.simple ];
          services.homebox.database.createLocally = true;
        };
      };
    in
    self;
  testScript = ''
    import json
    def test_homebox(node):
      node.wait_for_unit("homebox.service")
      node.wait_for_open_port(${port})

      node.succeed("curl --fail -X GET 'http://localhost:${port}/'")
      out = node.succeed("curl --fail 'http://localhost:${port}/api/v1/status'")
      assert '"health":true' in out
      node.succeed("curl --request POST --fail 'http://localhost:${port}/api/v1/users/register' \
        --data '{\"email\":\"a@b.c\",\"name\":\"test\",\"password\":\"password\"}' \
      ")
      login = node.succeed("curl --request POST --fail 'http://localhost:${port}/api/v1/users/login' \
        --data-urlencode 'password=password' \
        --data-urlencode 'username=a@b.c' \
      ")
      login_data = json.loads(login)
      token = login_data["token"]
      locations = node.succeed(f"curl --request GET --fail 'http://localhost:${port}/api/v1/locations' \
        --header 'Authorization: {token}' \
      ")
      location_id = json.loads(locations)[0]["id"]
      item = node.succeed(f"curl --request POST --fail 'http://localhost:${port}/api/v1/items' \
        --header 'Authorization: {token}' \
        --data '{{\"name\":\"testitem\",\"locationID\":\"{location_id}\"}}' \
      ")
      item_id = json.loads(item)["id"]
      node.succeed(f"curl --request POST --fail 'http://localhost:${port}/api/v1/items/{item_id}/attachments' \
        --header 'Authorization: {token}' \
        --form 'file=test;type=text/plain;filename=test.txt' \
        --form name=test.txt \
      ")

    test_homebox(simple)
    simple.send_monitor_command("quit")
    simple.wait_for_shutdown()
    test_homebox(postgres)
  '';
}
