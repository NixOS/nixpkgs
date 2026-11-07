{ lib, pkgs, ... }:
let
  template = pkgs.writeText "hebbot-template.md" ''
    # Integration news
    {% for key, entry in sections | dictsort %}
    ## {{ entry.section.title }}
    {% for item in entry.news %}
    {{ item.reporter_id }}: {{ item.message }}
    {% endfor %}
    {% endfor %}
  '';
in
{
  name = "hebbot";

  nodes.machine =
    { config, ... }:
    {
      services.matrix-synapse = {
        enable = true;
        settings = {
          server_name = "matrix.test";
          database.name = "sqlite3";
          enable_registration = true;
          enable_registration_without_verification = true;
          report_stats = false;
          rc_registration = {
            per_second = 100;
            burst_count = 100;
          };
          rc_message = {
            per_second = 100;
            burst_count = 100;
          };
          listeners = [
            {
              port = 8008;
              bind_addresses = [ "127.0.0.1" ];
              type = "http";
              tls = false;
              resources = [
                {
                  names = [ "client" ];
                  compress = false;
                }
              ];
            }
          ];
        };
      };

      services.hebbot = {
        enable = true;
        botPasswordFile = "/run/hebbot-password";
        dataDir = "/var/lib/hebbot-integration";
        inherit template;
        environment = {
          HOMESERVER_URL = "http://127.0.0.1:8008";
          RUST_LOG = "warn,hebbot=info";
        };
        settings = {
          bot_user_id = "@hebbot:matrix.test";
          reporting_room_id = "!reporting:matrix.test";
          admin_room_id = "!admin:matrix.test";
          notice_emoji = "⭕";
          restrict_notice = true;
          editors = [ "@editor:matrix.test" ];
          min_length = 10;
          ack_text = "Report stored for {{user}}";
          sections = [
            {
              name = "integration";
              title = "Integration section";
              emoji = "🧪";
              order = 100;
              usual_reporters = [ ];
            }
          ];
          projects = [ ];
        };
      };

      systemd.services.hebbot = {
        wantedBy = lib.mkForce [ ];
        serviceConfig.BindReadOnlyPaths = [
          "/run/hebbot-config.toml:${config.systemd.services.hebbot.environment.CONFIG_PATH}"
        ];
      };
    };

  testScript =
    { nodes, ... }:
    ''
      import json
      import secrets
      import shlex
      import time
      from datetime import timedelta
      from urllib.parse import quote

      start_all()
      machine.wait_for_unit("matrix-synapse.service")
      machine.wait_for_open_port(8008)
      machine.fail("systemctl is-active hebbot.service")

      def api(method, path, data=None, token=None, raw=False):
          command = ["curl", "--fail-with-body", "--silent", "--show-error", "--max-time", "30", "-X", method]
          if token:
              command += ["-H", "Authorization: Bearer " + token]
          if data is not None:
              command += ["-H", "Content-Type: application/json", "--data-binary", json.dumps(data)]
          command += ["http://127.0.0.1:8008/_matrix/" + path]
          result = machine.succeed(shlex.join(command))
          return result if raw else json.loads(result)

      def register(username, password):
          return api("POST", "client/v3/register", {
              "username": username,
              "password": password,
              "auth": {"type": "m.login.dummy"},
          })["access_token"]

      def runtime_file(path, contents):
          machine.succeed("umask 077; printf %s " + shlex.quote(contents) + " > " + shlex.quote(path))

      bot_id = "@hebbot:matrix.test"
      password = secrets.token_urlsafe(32)
      register("hebbot", password)
      editor = register("editor", secrets.token_urlsafe(32))
      reporter = register("reporter", secrets.token_urlsafe(32))
      runtime_file("/run/hebbot-password", password)
      machine.succeed("test $(stat -c %a /run/hebbot-password) = 600")

      def create_room(name):
          return api("POST", "client/v3/createRoom", {
              "name": name,
              "preset": "private_chat",
              "invite": [bot_id],
          }, editor)["room_id"]

      reporting_room = create_room("Reporting")
      admin_room = create_room("Administration")
      api("POST", "client/v3/rooms/" + quote(reporting_room, safe="") + "/invite", {
          "user_id": "@reporter:matrix.test",
      }, editor)
      api("POST", "client/v3/join/" + quote(reporting_room, safe=""), {}, reporter)
      for room in (reporting_room, admin_room):
          state = api("GET", "client/v3/rooms/" + quote(room, safe="") + "/state", token=editor)
          assert not any(event["type"] == "m.room.encryption" for event in state)

      config = machine.succeed("cat ${nodes.machine.systemd.services.hebbot.environment.CONFIG_PATH}")
      config = config.replace("!reporting:matrix.test", reporting_room).replace("!admin:matrix.test", admin_room)
      runtime_file("/run/hebbot-config.toml", config)
      machine.succeed("chmod 644 /run/hebbot-config.toml")

      def wait_for_sync():
          machine.wait_for_unit("hebbot.service")
          invocation = machine.succeed("systemctl show hebbot.service -p InvocationID --value").strip()
          try:
              machine.wait_until_succeeds(
                  "journalctl _SYSTEMD_INVOCATION_ID=" + invocation + " --no-pager | grep -F 'Started syncing'",
                  timeout=timedelta(seconds=120),
              )
          except Exception:
              machine.log(machine.succeed("journalctl -u hebbot.service --no-pager -n 100"))
              raise

      def send(room, content, token=editor, event_type="m.room.message"):
          return api("PUT", "client/v3/rooms/" + quote(room, safe="") + "/send/" + event_type + "/" + secrets.token_hex(16), content, token)["event_id"]

      def message(room, body):
          return send(room, {"msgtype": "m.text", "body": body})

      def wait_for_event(room, predicate, excluded=()):
          for _ in range(60):
              events = api("GET", "client/v3/rooms/" + quote(room, safe="") + "/messages?dir=b&limit=100", token=editor)["chunk"]
              for event in events:
                  if event["sender"] == bot_id and event["event_id"] not in excluded and predicate(event["content"]):
                      return event
              time.sleep(1)
          raise AssertionError("Timed out waiting for Hebbot in " + room)

      store_path = "${nodes.machine.services.hebbot.dataDir}/store.json"

      def wait_for_store(predicate):
          for _ in range(60):
              status, output = machine.execute("cat " + shlex.quote(store_path))
              if status == 0:
                  try:
                      store = json.loads(output)
                      if predicate(store):
                          return store
                  except json.JSONDecodeError:
                      pass
              time.sleep(1)
          raise AssertionError("Timed out waiting for persistent news")

      with subtest("startup with runtime credentials and invited rooms"):
          machine.systemctl("start hebbot.service")
          wait_for_sync()
          startup = wait_for_event(admin_room, lambda content: content.get("body") == "✅ Started hebbot!")
          for room in (reporting_room, admin_room):
              membership = api("GET", "client/v3/rooms/" + quote(room, safe="") + "/state/m.room.member/" + quote(bot_id, safe=""), token=editor)
              assert membership["membership"] == "join"
          message(admin_room, "!about")
          wait_for_event(admin_room, lambda content: "Hebbot version 3.0" in content.get("body", ""))
          unit = machine.succeed("systemctl cat hebbot.service")
          assert "LoadCredential=bot-password-file:/run/hebbot-password" in unit, unit

      with subtest("news submission and editor section reaction"):
          news = "The integration test preserves this news across a service restart."
          event_id = send(reporting_room, {
              "msgtype": "m.text",
              "body": "hebbot: " + news,
              "m.mentions": {"user_ids": [bot_id]},
          }, reporter)
          wait_for_event(reporting_room, lambda content: "Report stored for" in content.get("body", ""))
          wait_for_store(lambda store: event_id in store)
          reaction_id = send(reporting_room, {
              "m.relates_to": {"rel_type": "m.annotation", "event_id": event_id, "key": "🧪"},
          }, event_type="m.reaction")
          saved = wait_for_store(lambda store: store.get(event_id, {}).get("section_names", {}).get(reaction_id) == "integration")
          assert saved[event_id]["message"] == news
          assert saved[event_id]["reporter_id"] == "@reporter:matrix.test"
          wait_for_event(admin_room, lambda content: "@editor:matrix.test added @reporter:matrix.test" in content.get("body", "") and "Integration section" in content["body"])

      with subtest("persistent news and uploaded markdown after restart"):
          previous = machine.succeed("systemctl show hebbot.service -p InvocationID --value").strip()
          machine.systemctl("stop hebbot.service")
          persisted = json.loads(machine.succeed("cat " + shlex.quote(store_path)))
          assert persisted == saved
          machine.succeed("test $(stat -c %a " + shlex.quote(store_path) + ") = 600")
          machine.systemctl("start hebbot.service")
          wait_for_sync()
          assert machine.succeed("systemctl show hebbot.service -p InvocationID --value").strip() != previous
          wait_for_event(admin_room, lambda content: content.get("body") == "✅ Started hebbot!", excluded=[startup["event_id"]])
          assert json.loads(machine.succeed("cat " + shlex.quote(store_path))) == saved
          message(admin_room, "!render")
          attachment = wait_for_event(admin_room, lambda content: content.get("msgtype") == "m.file" and content.get("body") == "rendered.md")
          uri = attachment["content"]["url"]
          assert uri.startswith("mxc://matrix.test/")
          server, media_id = uri.removeprefix("mxc://").split("/", 1)
          markdown = api("GET", "client/v1/media/download/" + quote(server, safe="") + "/" + quote(media_id, safe=""), token=editor, raw=True)
          assert "# Integration news" in markdown
          assert "## Integration section" in markdown
          assert "@reporter:matrix.test: " + news in markdown
          assert markdown.count(news) == 1
          wait_for_event(admin_room, lambda content: "Rendered markdown is including 1 news, 0 image(s) and 0 video(s)!" in content.get("body", ""))
          assert machine.succeed("systemctl show hebbot.service -p NRestarts --value").strip() == "0"
          machine.succeed("test $(stat -c %a /run/hebbot-password) = 600")
          machine.wait_for_unit("hebbot.service")
    '';
}
