{ lib, pkgs, ... }:
let
  package = pkgs.paperclip;
  fakeGateway = pkgs.writeText "paperclip-fake-hermes.py" ''
    import json
    import re
    import urllib.error
    import urllib.request
    from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
    from pathlib import Path

    root = Path("/var/lib/hermes-fixture")
    runs = {}

    def call_controller(base, company_id, token):
        callback = urllib.request.Request(
            base + "/api/companies/" + company_id + "/issues?limit=1",
            headers={"Authorization": "Bearer " + token},
        )
        try:
            with urllib.request.urlopen(callback, timeout=10) as response:
                return response.status
        except urllib.error.HTTPError as error:
            return error.code

    class Gateway(BaseHTTPRequestHandler):
        def log_message(self, *args):
            pass

        def send_json(self, status, payload):
            body = json.dumps(payload).encode()
            self.send_response(status)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)

        def authorized(self):
            if self.headers.get("Authorization") == "Bearer " + (root / "gateway-key").read_text().strip():
                return True
            self.send_json(401, {"error": "unauthorized"})
            return False

        def do_POST(self):
            if not self.authorized():
                return
            if self.path == "/v1/runs":
                request = json.loads(self.rfile.read(int(self.headers["Content-Length"])))
                text = request.get("input", "")
                company = re.search(r"^- Company ID: ([0-9a-f-]+)$", text, re.M)
                base = re.search(r"^- Paperclip API URL: (http://[^\s]+)$", text, re.M)
                callback_status = None
                cross_company_status = None
                if company and base and (root / "callback-key").exists():
                    token = (root / "callback-key").read_text().strip()
                    callback_status = call_controller(base.group(1), company.group(1), token)
                    if (root / "other-company").exists():
                        cross_company_status = call_controller(base.group(1), (root / "other-company").read_text().strip(), token)
                run_id = "fixture-" + str(len(runs) + 1)
                held = root / "hold-next"
                status = "running" if held.exists() else "completed"
                held.unlink(missing_ok=True)
                runs[run_id] = {"status": status, "stops": 0, "callbackStatus": callback_status, "crossCompanyStatus": cross_company_status}
                self.send_json(200, {"run_id": run_id, "status": "started"})
            elif self.path.endswith("/stop"):
                run_id = self.path.split("/")[3]
                if run_id not in runs:
                    self.send_json(404, {"error": "missing"})
                    return
                runs[run_id]["status"] = "cancelled"
                runs[run_id]["stops"] += 1
                self.send_json(200, {"status": "cancelled"})
            else:
                self.send_json(404, {"error": "missing"})

        def do_GET(self):
            if self.path == "/__fixture/status":
                self.send_json(200, {"runs": runs})
                return
            if not self.authorized():
                return
            run_id = self.path.split("/")[3] if self.path.startswith("/v1/runs/") else ""
            run = runs.get(run_id)
            if run is None:
                self.send_json(404, {"error": "missing"})
            elif self.path.endswith("/events"):
                if run["status"] == "running":
                    self.send_response(204)
                    self.end_headers()
                    return
                body = ("event: run." + run["status"] + "\ndata: " + json.dumps({"status": run["status"], "output": "fixture completed"}) + "\n\n").encode()
                self.send_response(200)
                self.send_header("Content-Type", "text/event-stream")
                self.send_header("Content-Length", str(len(body)))
                self.end_headers()
                self.wfile.write(body)
            else:
                self.send_json(200, {"status": run["status"], "output": "fixture completed"})

    ThreadingHTTPServer(("0.0.0.0", 8642), Gateway).serve_forever()
  '';
in
{
  name = "paperclip";
  meta.maintainers = [ lib.maintainers.caniko ];
  nodes = {
    worker = { ... }: {
      virtualisation.memorySize = 1024;
      networking.firewall.allowedTCPPorts = [ 8642 ];
      users.groups.hermes-fixture = { };
      users.users.hermes-fixture = {
        isSystemUser = true;
        group = "hermes-fixture";
      };
      systemd.services.hermes-fixture-credentials = {
        requiredBy = [ "hermes-fixture.service" ];
        before = [ "hermes-fixture.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          umask 0077
          install -d -m 0700 -o hermes-fixture -g hermes-fixture /var/lib/hermes-fixture
          test -f /var/lib/hermes-fixture/gateway-key || ${pkgs.openssl}/bin/openssl rand -hex 32 > /var/lib/hermes-fixture/gateway-key
          chown hermes-fixture:hermes-fixture /var/lib/hermes-fixture/gateway-key
        '';
      };
      systemd.services.hermes-fixture = {
        wantedBy = [ "multi-user.target" ];
        after = [ "hermes-fixture-credentials.service" ];
        serviceConfig = {
          User = "hermes-fixture";
          Group = "hermes-fixture";
          ExecStart = "${pkgs.python3}/bin/python3 ${fakeGateway}";
          ProtectSystem = "strict";
          ProtectHome = true;
          ReadWritePaths = [ "/var/lib/hermes-fixture" ];
          NoNewPrivileges = true;
        };
      };
      environment.systemPackages = [
        pkgs.curl
        pkgs.jq
      ];
    };
    controller = { lib, ... }: {
      virtualisation = {
        memorySize = 8192;
        cores = 4;
        diskSize = 24576;
      };
      services.paperclip.instances.control = {
        enable = true;
        executionProfile = "trusted-local";
        host = "0.0.0.0";
        port = 3115;
        openFirewall = true;
        allowedHostnames = [ "controller" ];
        auth = {
          secretFile = "/var/lib/paperclip-control/credentials/auth";
          publicBaseUrl = "http://controller:3115";
        };
        database.local.enable = true;
        bootstrap = {
          email = "operator@example.test";
          name = "Fixture operator";
          passwordFile = "/var/lib/paperclip-control/credentials/password";
        };
        credentialFiles.gateway = "/var/lib/paperclip-control/credentials/gateway";
        manifest = {
          version = 1;
          owner = "split-network-fixture";
          companies.example.fields.name = "Split fixture";
          companies.other.fields.name = "Other company";
          agents.worker = {
            company = "example";
            fields = {
              name = "Remote worker";
              adapterType = "hermes_gateway";
              adapterConfig = {
                apiBaseUrl = "http://worker:8642";
                paperclipApiUrl = "http://controller:3115";
                dangerouslyAllowInsecureRemoteHttp = true;
              };
            };
            credentials.apiKey = "gateway";
          };
        };
      };
      systemd.services.paperclip-control.serviceConfig.Restart = lib.mkForce "no";
      systemd.services.paperclip-fixture-credentials = {
        requiredBy = [ "paperclip-control.service" ];
        before = [ "paperclip-control.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          umask 0077
          root=/var/lib/paperclip-control/credentials
          install -d -m 0700 -o paperclip-control -g paperclip-control "$root"
          for key in auth password; do
            test -f "$root/$key" || ${pkgs.openssl}/bin/openssl rand -hex 32 > "$root/$key"
            chown paperclip-control:paperclip-control "$root/$key"
          done
          install -m 0600 -o paperclip-control -g paperclip-control /tmp/shared/gateway-key "$root/gateway"
        '';
      };
      environment.systemPackages = [
        package
        pkgs.curl
        pkgs.jq
        pkgs.python3
      ];
    };
  };
  testScript = ''
    import json
    worker.start()
    worker.wait_for_open_port(8642)
    worker.fail("curl -fsS http://localhost:8642/v1/runs/unknown")
    worker.succeed("install -m 0600 /var/lib/hermes-fixture/gateway-key /tmp/shared/gateway-key")

    controller.start()
    controller.wait_until_succeeds("curl -fsS http://controller:3115/api/health | jq -e '.status == \"ok\"'", timeout=180)
    controller.fail("curl -fsS http://controller:3115/api/companies")
    worker.fail("test -e /var/lib/paperclip-control/credentials/auth")
    worker.fail("test -e /run/postgresql/.s.PGSQL.5432")
    controller.succeed("jq -n --rawfile password /var/lib/paperclip-control/credentials/password '{email: \"operator@example.test\", password: ($password | rtrimstr(\"\\n\"))}' > /run/login.json")
    controller.succeed("curl -fsS -c /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: http://controller:3115' --data-binary @/run/login.json http://controller:3115/api/auth/sign-in/email > /run/login-response.json")
    controller.succeed("jq -e '.user.email == \"operator@example.test\"' /run/login-response.json")
    print("Board cookie names:", controller.succeed("awk -F '\\t' 'NF == 7 { print $6 }' /run/board-cookies").strip())
    print("Board cookie scope:", controller.succeed("awk -F '\\t' 'NF == 7 { print $1, $2, $3, $4, $6 }' /run/board-cookies").strip())
    controller.succeed("curl -fsS -b /run/board-cookies http://controller:3115/api/auth/get-session > /run/board-session.json")
    controller.succeed("jq -e '.user.email == \"operator@example.test\"' /run/board-session.json")
    bindings = json.loads(controller.succeed("cat /var/lib/paperclip-control/instances/control/deployment-bindings.json"))["bindings"]
    agent_id = bindings["agent/worker"]
    controller.succeed(f"printf '%s\\n' {bindings['company/other']} > /tmp/shared/other-company")
    worker.succeed("install -m 0644 -o hermes-fixture -g hermes-fixture /tmp/shared/other-company /var/lib/hermes-fixture/other-company")
    controller.succeed("rm /tmp/shared/other-company")
    controller.succeed(f"curl -fsS -b /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: http://controller:3115' --data '{{\"name\":\"callback\"}}' http://controller:3115/api/agents/{agent_id}/keys > /run/callback-key.json")
    key_id = json.loads(controller.succeed("cat /run/callback-key.json"))["id"]
    controller.succeed("jq -r .token /run/callback-key.json > /tmp/shared/callback-key && chmod 0600 /tmp/shared/callback-key")
    worker.succeed("install -m 0600 -o hermes-fixture -g hermes-fixture /tmp/shared/callback-key /var/lib/hermes-fixture/callback-key")
    controller.succeed("rm /tmp/shared/gateway-key /tmp/shared/callback-key")

    def invoke():
        controller.succeed(f"curl -fsS -b /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: http://controller:3115' --data '{{}}' http://controller:3115/api/agents/{agent_id}/heartbeat/invoke > /run/invoked.json")
        run_id = json.loads(controller.succeed("cat /run/invoked.json"))["id"]
        controller.wait_until_succeeds(f"curl -fsS -b /run/board-cookies http://controller:3115/api/heartbeat-runs/{run_id} | jq -e '.status == \"succeeded\"'", timeout=120)
        return run_id

    invoke()
    worker.succeed("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-1\"].callbackStatus == 200 and .runs[\"fixture-1\"].crossCompanyStatus == 403'")
    controller.succeed("systemctl restart paperclip-control.service")
    controller.wait_until_succeeds("curl -fsS http://controller:3115/api/health | jq -e '.status == \"ok\"'", timeout=120)
    assert json.loads(controller.succeed("cat /var/lib/paperclip-control/instances/control/deployment-bindings.json"))["bindings"] == bindings
    invoke()
    worker.succeed("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-2\"].callbackStatus == 200 and .runs[\"fixture-2\"].crossCompanyStatus == 403'")
    controller.succeed(f"curl -fsS -X DELETE -b /run/board-cookies -H 'Origin: http://controller:3115' http://controller:3115/api/agents/{agent_id}/keys/{key_id} > /run/revoked.json")
    invoke()
    worker.succeed("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-3\"].callbackStatus == 401'")
    worker.succeed("install -m 0600 -o hermes-fixture -g hermes-fixture /dev/null /var/lib/hermes-fixture/hold-next")
    controller.succeed(f"curl -fsS -b /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: http://controller:3115' --data '{{}}' http://controller:3115/api/agents/{agent_id}/heartbeat/invoke > /run/active.json")
    active_id = json.loads(controller.succeed("cat /run/active.json"))["id"]
    worker.wait_until_succeeds("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-4\"].status == \"running\"'", timeout=120)
    controller.succeed(f"curl -fsS -b /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: http://controller:3115' --data '{{}}' http://controller:3115/api/heartbeat-runs/{active_id}/cancel > /run/cancelled.json")
    controller.wait_until_succeeds(f"curl -fsS -b /run/board-cookies http://controller:3115/api/heartbeat-runs/{active_id} | jq -e '.status == \"cancelled\" and .resultJson.executionCancellation.state == \"acknowledged\"'", timeout=120)
    worker.succeed("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-4\"].status == \"cancelled\" and .runs[\"fixture-4\"].stops == 1'")
    worker.succeed("install -m 0600 -o hermes-fixture -g hermes-fixture /dev/null /var/lib/hermes-fixture/hold-next")
    controller.succeed(f"curl -fsS -b /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: http://controller:3115' --data '{{}}' http://controller:3115/api/agents/{agent_id}/heartbeat/invoke > /run/restart-active.json")
    restart_id = json.loads(controller.succeed("cat /run/restart-active.json"))["id"]
    worker.wait_until_succeeds("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-5\"].status == \"running\"'", timeout=120)
    controller.succeed("systemctl restart paperclip-control.service")
    controller.wait_until_succeeds("curl -fsS http://controller:3115/api/health | jq -e '.status == \"ok\"'", timeout=120)
    controller.wait_until_succeeds(f"curl -fsS -b /run/board-cookies http://controller:3115/api/heartbeat-runs/{restart_id} | jq -e '.status == \"cancelled\" and .resultJson.executionCancellation.state == \"acknowledged\"'", timeout=120)
    worker.succeed("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-5\"].status == \"cancelled\" and .runs[\"fixture-5\"].stops == 1'")
    controller.succeed("pid=$(systemctl show paperclip-control -p MainPID --value); ! tr '\\0' '\\n' < /proc/$pid/environ | grep -E '^(BETTER_AUTH_SECRET|DATABASE_URL|DATABASE_MIGRATION_URL)='")
  '';
}
