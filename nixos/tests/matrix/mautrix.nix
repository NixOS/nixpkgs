# The external networks require real accounts. Exercise the Matrix side of each
# bridge without logging in to Telegram, Signal, or WhatsApp.
{ bridgeType }:
{ lib, pkgs, ... }:
let
  unit = "mautrix-${bridgeType}";
  dataDir = "/var/lib/${unit}";
  registrationFile = "${dataDir}/${bridgeType}-registration.yaml";
  encryption = {
    allow = false;
    default = false;
    require = false;
  };
in
{
  name = unit;
  meta.maintainers = pkgs.${unit}.meta.maintainers;

  nodes.machine = {
    services.matrix-synapse = {
      enable = true;
      settings = {
        server_name = "homeserver";
        database.name = "sqlite3";
        enable_registration = true;
        # Test-only: no registration verification is needed in the isolated VM.
        enable_registration_without_verification = true;
        listeners = [
          {
            bind_addresses = [ "127.0.0.1" ];
            port = 8008;
            type = "http";
            tls = false;
            resources = [ { names = [ "client" ]; } ];
          }
        ];
      };
    };

    services.mautrix.bridges.${bridgeType} = {
      type = bridgeType;
      environmentFiles = [
        (pkgs.writeText "mautrix-test-first.env" ''
          BOT_DISPLAYNAME="First bridge bot"
        '')
        (pkgs.writeText "mautrix-test-secrets.env" ''
          BOT_DISPLAYNAME="Test bridge bot"
          MAUTRIX_BRIDGE_LOGIN_SHARED_SECRET=as_token:double-puppet-test-secret
          MAUTRIX_TELEGRAM_NETWORK__API_ID=123456
          MAUTRIX_TELEGRAM_NETWORK__API_HASH=0123456789abcdef0123456789abcdef
        '')
      ];
      settings =
        lib.recursiveUpdate
          {
            homeserver.address = "http://127.0.0.1:8008";
            appservice = {
              id = bridgeType;
              hostname = "127.0.0.1";
              address = "http://127.0.0.1:8009";
              port = 8009;
            };
            bridge = {
              command_prefix = "!test";
              permissions."@alice:homeserver" = "user";
            };
          }
          {
            inherit encryption;
            appservice.bot.displayname = "$BOT_DISPLAYNAME";
          };
    };

    environment.systemPackages = [
      pkgs.curl
      pkgs.jq
      pkgs.yq
    ];
  };

  testScript = ''
    import json
    import shlex
    from urllib.parse import quote

    def api_command(method, path, data=None, token=None):
        args = ["curl", "--fail", "--silent", "--show-error", "-X", method]
        if token:
            args += ["-H", f"Authorization: Bearer {token}"]
        if data is not None:
            args += ["-H", "Content-Type: application/json", "--data", json.dumps(data)]
        args += ["http://127.0.0.1:8008/_matrix/client/" + path]
        return shlex.join(args)

    def api(method, path, data=None, token=None):
        return json.loads(machine.succeed(api_command(method, path, data, token)))

    def config_value(expression):
        return machine.succeed(f"yq -r {shlex.quote(expression)} ${dataDir}/config.yaml").strip()

    def ping_bridge():
        machine.wait_until_succeeds(api_command(
            "POST", "v1/appservice/${bridgeType}/ping?user_id=" + quote(bot_id, safe=""),
            {}, as_token,
        ))

    start_all()
    bot_id = "@${bridgeType}bot:homeserver"

    with subtest("cold boot registers the bridge before Synapse starts"):
        machine.wait_for_unit("matrix-synapse.service")
        machine.wait_for_unit("${unit}-registration.service")
        machine.wait_for_unit("${unit}.service")
        machine.wait_for_open_port(8009)
        as_token = config_value(".appservice.as_token")
        hs_token = config_value(".appservice.hs_token")
        assert as_token and hs_token
        ping_bridge()

    with subtest("tokens, environment files, and registration permissions"):
        registration = json.loads(machine.succeed("yq . ${registrationFile}"))
        assert registration["as_token"] == as_token
        assert registration["hs_token"] == hs_token
        assert registration["rate_limited"] is False
        assert config_value(".homeserver.domain") == "homeserver"
        assert config_value(".appservice.bot.displayname") == "Test bridge bot"
        assert config_value(".double_puppet.secrets[\"homeserver\"]") == "as_token:double-puppet-test-secret"
        assert config_value(".env_config_prefix") == "MAUTRIX_${lib.toUpper bridgeType}_"
        assert machine.succeed("stat -c %a ${dataDir}/config.yaml").strip() == "600"
        assert machine.succeed("stat -c %a ${registrationFile}").strip() == "640"
        machine.succeed("su matrix-synapse -s /bin/sh -c 'test -r ${registrationFile}'")
        machine.fail("su matrix-synapse -s /bin/sh -c 'test -r ${dataDir}/config.yaml'")

    with subtest("the bridge bot answers Matrix messages without an external account"):
        token = api("POST", "v3/register", {
            "username": "alice", "password": "test-password",
            "auth": {"type": "m.login.dummy"},
        })["access_token"]
        room = api("POST", "v3/createRoom", {
            "is_direct": True, "invite": [bot_id],
            "preset": "trusted_private_chat",
        }, token)["room_id"]
        room_path = "v3/rooms/" + quote(room, safe="")
        api("PUT", room_path + "/send/m.room.message/help", {
            "msgtype": "m.text", "body": "!test help",
        }, token)
        messages = api_command("GET", room_path + "/messages?dir=b&limit=20", token=token)
        machine.wait_until_succeeds(
            messages + " | jq -e " + shlex.quote(
                'any(.chunk[]; .sender == "' + bot_id + '" and .type == "m.room.message")'
            )
        )

    with subtest("regenerating registration and restarting preserves tokens"):
        machine.succeed("systemctl restart ${unit}-registration.service")
        machine.succeed("systemctl restart ${unit}.service")
        machine.wait_for_unit("${unit}.service")
        assert config_value(".appservice.as_token") == as_token
        assert config_value(".appservice.hs_token") == hs_token
        registration = json.loads(machine.succeed("yq . ${registrationFile}"))
        assert registration["as_token"] == as_token
        assert registration["hs_token"] == hs_token
        ping_bridge()
  '';
}
