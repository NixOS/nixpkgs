{ pkgs, ... }:
let
  port = "7745";
in
{
  name = "homebox";
  meta = {
    inherit (pkgs.homebox.meta) maintainers;
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

        explicitPepper =
          {
            config,
            lib,
            ...
          }:
          let
            inherit (config.services.homebox)
              user
              group
              ;
          in
          {
            systemd.tmpfiles.rules = [
              "d /run/homebox 0700 ${user} ${group}"
              "f /run/homebox/pepper 0400 ${user} ${group} - 0a7524fa7b4555ab793c177557b7b8db6619b47cc0574fb99716315e03b6ddf1d67961ee9bf36b19bef448ed3e530957"
            ];
            imports = [ self.simple ];
            services.homebox = {
              secrets = {
                HBOX_AUTH_API_KEY_PEPPER = "/run/homebox/pepper";
              };
            };
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
    test_homebox(explicitPepper)
  '';
}
