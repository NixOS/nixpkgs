{
  lib,
  pkgs,
  ...
}:
let
  package = pkgs.paperclip;
  shared = import ../modules/services/misc/paperclip-shared.nix { inherit lib pkgs; };
  validateConfig = pkgs.writeText "paperclip-validate-fixture-config.mjs" ''
    import { readFileSync } from "node:fs";
    import { paperclipConfigSchema } from "${package}/lib/paperclip/packages/shared/src/config-schema.ts";

    paperclipConfigSchema.parse(JSON.parse(readFileSync(process.argv[2], "utf8")));
  '';
  fakeGateway = pkgs.writeText "paperclip-fake-hermes.py" ''
    import json
    import re
    import threading
    import urllib.error
    import urllib.request
    from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
    from pathlib import Path

    root = Path("/var/lib/hermes-fixture")
    runs = {}
    admissions = {}
    payloads = {}
    admission_lock = threading.Lock()

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
            with admission_lock:
                self.handle_post()

        def handle_post(self):
            if self.path in ("/v1/runs", "/v1/runs/stop"):
                key = self.headers.get("Idempotency-Key")
                if not key:
                    self.send_json(400, {"error": "idempotency key required"})
                    return
                request = json.loads(self.rfile.read(int(self.headers["Content-Length"])))
                context = request.get("execution_context", {})
                if (context.get("version") != 1 or context.get("backend") != "local"
                        or context.get("lifetime") != "wait_for_jobs"
                        or not isinstance(context.get("cwd"), str) or not context["cwd"].startswith("/")):
                    self.send_json(422, {"error": "unsupported execution context"})
                    return
                if key in admissions:
                    if request != payloads[key]:
                        self.send_json(409, {"error": "admission binding changed"})
                        return
                    run_id = admissions[key]
                    if self.path == "/v1/runs/stop" and not (root / "stop-blocked").exists():
                        if runs[run_id]["status"] == "running":
                            runs[run_id]["status"] = "cancelled"
                            runs[run_id]["stops"] += 1
                    self.send_json(200, {"run_id": run_id, "status": runs[run_id]["status"]})
                    return
                if self.path == "/v1/runs/stop":
                    # Fence missing admission without starting any provider work.
                    run_id = "fixture-" + str(len(runs) + 1)
                    admissions[key] = run_id
                    payloads[key] = request
                    runs[run_id] = {"status": "cancelled", "stops": 0}
                    self.send_json(200, {"run_id": run_id, "status": "cancelled"})
                    return
            if self.path == "/v1/runs":
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
                admissions[key] = run_id
                payloads[key] = request
                self.send_json(200, {"run_id": run_id, "status": "started"})
            elif self.path.endswith("/stop"):
                run_id = self.path.split("/")[3]
                if run_id not in runs:
                    self.send_json(404, {"error": "missing"})
                    return
                if not (root / "stop-blocked").exists() and runs[run_id]["status"] == "running":
                    runs[run_id]["status"] = "cancelled"
                    runs[run_id]["stops"] += 1
                self.send_json(200, {"run_id": run_id, "status": runs[run_id]["status"]})
            else:
                self.send_json(404, {"error": "missing"})

        def do_GET(self):
            if self.path == "/__fixture/status":
                self.send_json(200, {"runs": runs})
                return
            if not self.authorized():
                return
            if self.path == "/v1/capabilities":
                self.send_json(200, {"features": {"runs_execution_context": {
                    "version": 1, "mode": "precondition", "backends": ["local"],
                    "lifetimes": ["wait_for_jobs"], "stop_admission": True,
                }}})
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
                self.send_json(200, {"run_id": run_id, "status": run["status"], "output": "fixture completed"})

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
    controller =
      {
        lib,
        config,
        ...
      }:
      {
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
          allowedHostnames = [
            "controller"
            "localhost"
          ];
          auth = {
            secretFile = "/var/lib/paperclip-control/credentials/auth";
            publicBaseUrl = "http://localhost:3115";
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
                  waitForJobs = true;
                };
              };
              credentials.apiKey = "gateway";
            };
          };
        };
        systemd.services.paperclip-control.serviceConfig.Restart = lib.mkForce "no";
        # Startup recovery and explicit Stop own this deterministic journey.
        # Keep a periodic sweep from racing the final verified-stop assertion.
        systemd.services.paperclip-control.environment.HEARTBEAT_SCHEDULER_INTERVAL_MS = "3600000";
        environment.etc."paperclip-fixture-config.json".source =
          (shared.render "control" config.services.paperclip.instances.control).configFile;
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
          config.services.postgresql.package
          pkgs.curl
          pkgs.jq
          pkgs.python3
          pkgs.util-linux
        ];
      };
  };
  testScript = ''
    import json
    import shlex
    from uuid import UUID
    board_url = "http://localhost:3115"
    worker.start()
    worker.wait_for_open_port(8642)
    worker.fail("curl -fsS http://localhost:8642/v1/runs/unknown")
    worker.succeed("install -m 0600 /var/lib/hermes-fixture/gateway-key /tmp/shared/gateway-key")

    controller.start()
    controller.succeed("${pkgs.nodejs}/bin/node --import ${package}/lib/paperclip/server/node_modules/tsx/dist/loader.mjs ${validateConfig} /etc/paperclip-fixture-config.json")
    try:
        controller.wait_until_succeeds("curl -fsS http://controller:3115/api/health | jq -e '.status == \"ok\"'", timeout=180)
    except Exception:
        print(controller.execute("systemctl show paperclip-control.service -p Result -p ExecMainStatus -p ExecMainCode"))
        print(controller.execute("journalctl -u paperclip-control.service -n 80 --no-pager -o cat"))
        raise
    controller.fail("curl -fsS http://controller:3115/api/companies")
    worker.fail("test -e /var/lib/paperclip-control/credentials/auth")
    worker.fail("test -e /run/postgresql/.s.PGSQL.5432")
    controller.succeed("jq -n --rawfile password /var/lib/paperclip-control/credentials/password '{email: \"operator@example.test\", password: ($password | rtrimstr(\"\\n\"))}' > /run/login.json")
    controller.succeed(f"curl -fsS -c /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: {board_url}' --data-binary @/run/login.json {board_url}/api/auth/sign-in/email > /run/login-response.json")
    controller.succeed("jq -e '.user.email == \"operator@example.test\"' /run/login-response.json")
    controller.succeed(f"curl -fsS -b /run/board-cookies {board_url}/api/auth/get-session > /run/board-session.json")
    controller.succeed("jq -e '.user.email == \"operator@example.test\"' /run/board-session.json")
    bindings = json.loads(controller.succeed("cat /var/lib/paperclip-control/instances/control/deployment-bindings.json"))["bindings"]
    agent_id = bindings["agent/worker"]
    controller.succeed(f"printf '%s\\n' {bindings['company/other']} > /tmp/shared/other-company")
    worker.succeed("install -m 0644 -o hermes-fixture -g hermes-fixture /tmp/shared/other-company /var/lib/hermes-fixture/other-company")
    controller.succeed("rm /tmp/shared/other-company")
    controller.succeed(f"curl -fsS -b /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: {board_url}' --data '{{\"name\":\"callback\"}}' {board_url}/api/agents/{agent_id}/keys > /run/callback-key.json")
    key_id = json.loads(controller.succeed("cat /run/callback-key.json"))["id"]
    controller.succeed("jq -r .token /run/callback-key.json > /tmp/shared/callback-key && chmod 0600 /tmp/shared/callback-key")
    worker.succeed("install -m 0600 -o hermes-fixture -g hermes-fixture /tmp/shared/callback-key /var/lib/hermes-fixture/callback-key")
    controller.succeed("rm /tmp/shared/gateway-key /tmp/shared/callback-key")

    def invoke():
        controller.succeed(f"curl -fsS -b /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: {board_url}' --data '{{}}' {board_url}/api/agents/{agent_id}/heartbeat/invoke > /run/invoked.json")
        run_id = json.loads(controller.succeed("cat /run/invoked.json"))["id"]
        controller.wait_until_succeeds(f"curl -fsS -b /run/board-cookies {board_url}/api/heartbeat-runs/{run_id} | jq -e '.status == \"succeeded\"'", timeout=120)
        return run_id

    invoke()
    worker.succeed("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-1\"].callbackStatus == 200 and .runs[\"fixture-1\"].crossCompanyStatus == 403'")
    controller.succeed("systemctl restart paperclip-control.service")
    controller.wait_until_succeeds("curl -fsS http://controller:3115/api/health | jq -e '.status == \"ok\"'", timeout=120)
    assert json.loads(controller.succeed("cat /var/lib/paperclip-control/instances/control/deployment-bindings.json"))["bindings"] == bindings
    invoke()
    worker.succeed("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-2\"].callbackStatus == 200 and .runs[\"fixture-2\"].crossCompanyStatus == 403'")
    controller.succeed(f"curl -fsS -X DELETE -b /run/board-cookies -H 'Origin: {board_url}' {board_url}/api/agents/{agent_id}/keys/{key_id} > /run/revoked.json")
    invoke()
    worker.succeed("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-3\"].callbackStatus == 401'")
    worker.succeed("install -m 0600 -o hermes-fixture -g hermes-fixture /dev/null /var/lib/hermes-fixture/hold-next")
    controller.succeed(f"curl -fsS -b /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: {board_url}' --data '{{}}' {board_url}/api/agents/{agent_id}/heartbeat/invoke > /run/active.json")
    active_id = json.loads(controller.succeed("cat /run/active.json"))["id"]
    worker.wait_until_succeeds("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-4\"].status == \"running\"'", timeout=120)
    controller.succeed(f"curl -fsS -b /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: {board_url}' --data '{{}}' {board_url}/api/heartbeat-runs/{active_id}/cancel > /run/cancelled.json")
    controller.wait_until_succeeds(f"curl -fsS -b /run/board-cookies {board_url}/api/heartbeat-runs/{active_id} | jq -e '.status == \"cancelled\" and .resultJson.executionCancellation.state == \"acknowledged\"'", timeout=120)
    worker.succeed("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-4\"].status == \"cancelled\" and .runs[\"fixture-4\"].stops == 1'")
    worker.succeed("install -m 0600 -o hermes-fixture -g hermes-fixture /dev/null /var/lib/hermes-fixture/hold-next")
    controller.succeed(f"curl -fsS -b /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: {board_url}' --data '{{}}' {board_url}/api/agents/{agent_id}/heartbeat/invoke > /run/restart-active.json")
    restart_id = json.loads(controller.succeed("cat /run/restart-active.json"))["id"]
    worker.wait_until_succeeds("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-5\"].status == \"running\"'", timeout=120)
    controller.succeed("systemctl restart paperclip-control.service")
    controller.wait_until_succeeds("curl -fsS http://controller:3115/api/health | jq -e '.status == \"ok\"'", timeout=120)
    controller.wait_until_succeeds(f"curl -fsS -b /run/board-cookies {board_url}/api/heartbeat-runs/{restart_id} | jq -e '.status == \"cancelled\" and .resultJson.executionCancellation.state == \"acknowledged\"'", timeout=120)
    worker.succeed("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-5\"].status == \"cancelled\" and .runs[\"fixture-5\"].stops == 1'")
    # The default permits concurrent runs; bound this agent to one slot so a
    # second board invoke is a genuine queued successor before the crash.
    serial_policy = json.dumps({"runtimeConfig": {"heartbeat": {"wakeOnDemand": True, "maxConcurrentRuns": 1}}})
    controller.succeed(f"curl -fsS -X PATCH -b /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: {board_url}' --data '{serial_policy}' {board_url}/api/agents/{agent_id} > /run/serial-agent.json")
    controller.succeed("jq -e '.runtimeConfig.heartbeat.maxConcurrentRuns == 1' /run/serial-agent.json")
    worker.succeed("install -m 0600 -o hermes-fixture -g hermes-fixture /dev/null /var/lib/hermes-fixture/hold-next")
    controller.succeed(f"curl -fsS -b /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: {board_url}' --data '{{}}' {board_url}/api/agents/{agent_id}/heartbeat/invoke > /run/crash-active.json")
    crash_id = str(UUID(json.loads(controller.succeed("cat /run/crash-active.json"))["id"]))
    worker.wait_until_succeeds("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-6\"].status == \"running\"'", timeout=120)
    controller.succeed(f"curl -fsS -b /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: {board_url}' --data '{{}}' {board_url}/api/agents/{agent_id}/heartbeat/invoke > /run/crash-successor.json")
    successor_id = str(UUID(json.loads(controller.succeed("cat /run/crash-successor.json"))["id"]))
    company_id = str(UUID(bindings["company/example"]))

    def owned_lease():
        # Read only bounded public state and ciphertext presence, never material.
        query = f"SELECT json_build_object('id', id, 'status', status, 'releasedAt', released_at, 'state', metadata->'adapterExecution'->>'state', 'sealed', metadata->'adapterExecution' ? 'material') FROM environment_leases WHERE heartbeat_run_id = '{crash_id}' AND company_id = '{company_id}'"
        return json.loads(controller.succeed("runuser -u postgres -- psql -At -v ON_ERROR_STOP=1 -d paperclip_control -c " + shlex.quote(query)))

    crash_lease = owned_lease()
    assert crash_lease["status"] == "active" and crash_lease["releasedAt"] is None
    assert crash_lease["state"] == "pending" and crash_lease["sealed"] is True
    old_controller_boot_id = controller.succeed(f"curl -fsS -b /run/board-cookies {board_url}/api/heartbeat-runs/{crash_id} | jq -er .controllerBootId").strip()
    UUID(old_controller_boot_id)
    worker.succeed("install -m 0600 -o hermes-fixture -g hermes-fixture /dev/null /var/lib/hermes-fixture/stop-blocked")
    controller.succeed(f"curl -fsS -b /run/board-cookies {board_url}/api/heartbeat-runs/{successor_id} | jq -e '.status == \"queued\"'")
    controller.succeed("systemctl kill -s SIGKILL paperclip-control.service")
    controller.wait_until_succeeds("systemctl is-failed paperclip-control.service", timeout=30)
    worker.succeed("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-6\"].status == \"running\" and (.runs | length) == 6'")
    controller.succeed(f"runuser -u postgres -- psql -At -d paperclip_control -c \"UPDATE heartbeat_runs SET controller_lease_expires_at = clock_timestamp() - interval '1 second' WHERE id = '{crash_id}' AND status = 'running' RETURNING id\" | grep -Fx {crash_id}")
    controller.succeed("systemctl reset-failed paperclip-control.service")
    controller.succeed("systemctl start paperclip-control.service")
    controller.wait_until_succeeds("curl -fsS http://controller:3115/api/health | jq -e '.status == \"ok\"'", timeout=120)
    try:
        # Expiry grants cleanup authority, never permission to infer settlement.
        # A changed boot identity proves the new controller attempted recovery.
        controller.wait_until_succeeds(f"curl -fsS -b /run/board-cookies {board_url}/api/heartbeat-runs/{crash_id} | jq -e '.status == \"running\" and .controllerBootId != \"{old_controller_boot_id}\"'", timeout=120)
        assert owned_lease() == crash_lease
    finally:
        print(controller.succeed(f"curl -fsS -b /run/board-cookies {board_url}/api/heartbeat-runs/{crash_id} | jq '{{id,status,errorCode,controllerBootId,executionStage,finishedAt}}'"))
        print(json.dumps(owned_lease()))
    controller.succeed(f"curl -fsS -b /run/board-cookies {board_url}/api/heartbeat-runs/{successor_id} | jq -e '.status == \"queued\"'")
    worker.succeed("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-6\"].status == \"running\" and (.runs | length) == 6'")
    controller.succeed(f"curl -fsS -b /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: {board_url}' --data '{{}}' {board_url}/api/heartbeat-runs/{crash_id}/cancel | jq -e '.status == \"running\" and .errorCode == \"adapter_execution_settlement_pending\"'")
    controller.succeed(f"curl -fsS -b /run/board-cookies {board_url}/api/heartbeat-runs/{crash_id} | jq -e '.status == \"running\"'")
    assert owned_lease() == crash_lease
    controller.succeed("systemctl stop paperclip-control.service")
    controller.succeed("runuser -u postgres -- pg_dump -Fc -f /var/lib/postgresql/paperclip-control.dump paperclip_control")
    controller.succeed("runuser -u postgres -- dropdb --force paperclip_control")
    controller.succeed("runuser -u postgres -- createdb -O paperclip-control-migration paperclip_control")
    controller.succeed("runuser -u postgres -- pg_restore --no-owner --role=paperclip-control-migration -d paperclip_control /var/lib/postgresql/paperclip-control.dump")
    controller.succeed("systemctl start paperclip-control.service")
    controller.wait_until_succeeds("curl -fsS http://controller:3115/api/health | jq -e '.status == \"ok\"'", timeout=120)
    assert json.loads(controller.succeed("cat /var/lib/paperclip-control/instances/control/deployment-bindings.json"))["bindings"] == bindings
    controller.succeed(f"curl -fsS -b /run/board-cookies {board_url}/api/auth/get-session | jq -e '.user.email == \"operator@example.test\"'")
    controller.succeed(f"curl -fsS -b /run/board-cookies {board_url}/api/heartbeat-runs/{crash_id} | jq -e '.status == \"running\"'")
    assert owned_lease() == crash_lease
    controller.succeed(f"curl -fsS -b /run/board-cookies {board_url}/api/heartbeat-runs/{successor_id} | jq -e '.status == \"queued\"'")
    worker.succeed("curl -fsS http://localhost:8642/__fixture/status | jq -e '(.runs | length) == 6'")
    # Probe the saved revoked key directly while restored ownership still holds.
    revoked_callback_probe = f"""
    import urllib.error
    import urllib.request
    from pathlib import Path

    request = urllib.request.Request(
        "http://controller:3115/api/companies/{company_id}/issues?limit=1",
        headers=dict(Authorization="Bearer " + Path("/var/lib/hermes-fixture/callback-key").read_text().strip()),
    )
    try:
        with urllib.request.urlopen(request, timeout=10) as response:
            status = response.status
    except urllib.error.HTTPError as error:
        status = error.code
    assert status == 401, "Restored revoked callback key returned HTTP " + str(status)
    """
    worker.succeed("${pkgs.python3}/bin/python3 -c " + shlex.quote(revoked_callback_probe))
    assert owned_lease() == crash_lease
    controller.succeed(f"curl -fsS -b /run/board-cookies {board_url}/api/heartbeat-runs/{crash_id} | jq -e '.status == \"running\"'")
    controller.succeed(f"curl -fsS -b /run/board-cookies {board_url}/api/heartbeat-runs/{successor_id} | jq -e '.status == \"queued\"'")
    worker.succeed("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-6\"].status == \"running\" and (.runs | length) == 6'")
    # Only a verified parent-terminal response releases the restored checkpoint.
    worker.succeed("rm /var/lib/hermes-fixture/stop-blocked")
    controller.succeed(f"curl -fsS -b /run/board-cookies -H 'Content-Type: application/json' -H 'Origin: {board_url}' --data '{{}}' {board_url}/api/heartbeat-runs/{crash_id}/cancel | jq -e '.status == \"cancelled\" and .resultJson.executionCancellation.state == \"acknowledged\"'")
    settled_lease = owned_lease()
    assert settled_lease["id"] == crash_lease["id"] and settled_lease["releasedAt"] is not None
    assert settled_lease["state"] == "settled" and settled_lease["sealed"] is False
    controller.wait_until_succeeds(f"curl -fsS -b /run/board-cookies {board_url}/api/heartbeat-runs/{successor_id} | jq -e '.status == \"succeeded\"'", timeout=120)
    worker.succeed("curl -fsS http://localhost:8642/__fixture/status | jq -e '.runs[\"fixture-6\"].status == \"cancelled\" and .runs[\"fixture-6\"].stops == 1 and .runs[\"fixture-7\"].status == \"completed\" and .runs[\"fixture-7\"].callbackStatus == 401 and (.runs | length) == 7'")
    controller.succeed("pid=$(systemctl show paperclip-control -p MainPID --value); ! tr '\\0' '\\n' < /proc/$pid/environ | grep -E '^(BETTER_AUTH_SECRET|DATABASE_URL|DATABASE_MIGRATION_URL)='")
  '';
}
