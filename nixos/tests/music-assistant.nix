{
  lib,
  ...
}:

{
  name = "music-assistant";
  meta.maintainers = with lib.maintainers; [ hexa ];

  nodes.machine = {
    services.music-assistant = {
      enable = true;
      providers = [
        "sendspin"
      ];
    };
  };

  testScript = # python
    ''
      import json

      machine.wait_for_unit("music-assistant.service")
      machine.wait_for_open_port(8095)
      machine.wait_until_succeeds("curl --fail http://localhost:8095/info")

      machine.log(machine.succeed("systemd-analyze security music-assistant.service | grep -v ✓"))

      machine.succeed("""curl --fail http://localhost:8095/setup \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d '{
          "username": "hotblack_desiato",
          "password": "disaster_area",
          "display_name": "NixOS ♡ Music"
        }'""")

      login = json.loads(machine.succeed("""curl --fail http://localhost:8095/auth/login \
        -X POST \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d '{
          "provider_id": "builtin",
          "credentials": {
            "username": "hotblack_desiato",
            "password": "disaster_area"
          }
        }'"""))

      providers = json.loads(machine.succeed(f"""curl --fail http://localhost:8095/api \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -H 'Authorization: Bearer {login["token"]}' \
        -d '{{
          "command": "providers/manifests",
          "args": {{}}
        }}'"""))

      assert any(
        provider["type"] == "player" and provider["domain"] == "sendspin"
        for provider in providers
      )
    '';
}
