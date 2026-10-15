{ lib, ... }:
{
  name = "tdarr";
  meta = with lib.maintainers; {
    maintainers = [ mistyttm ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.tdarr = {
        enable = true;
        server = {
          serverPort = 9266;
          webUIPort = 9265;
        };
        nodes = {
          main = {
            name = "tdarr-main-custom";
            serverURL = "http://127.0.0.1:9266";
            serverIP = "127.0.0.1";
            serverPort = 9266;
            environmentFile = pkgs.writeText "tdarr-node-env" ''
              apiKey=tapi_test_node_key
            '';
            type = "mapped";
            priority = 7;
            pollInterval = 4321;
            startPaused = false;
            maxLogSizeMB = 42;
            cronPluginUpdate = "*/15 * * * *";
            pathTranslators = [
              {
                server = "/mnt/server/cache";
                node = "/mnt/node/cache";
              }
              {
                server = "/mnt/server/media";
                node = "/mnt/node/media";
              }
            ];
            workers = {
              transcodeGPU = 1;
              transcodeCPU = 3;
              healthcheckGPU = 1;
              healthcheckCPU = 2;
            };
          };
          secondary = {
            enable = false;
          };
        };
      };
    };

  testScript = ''
    import json
    import time

    def assert_any(value, accepted, message):
        assert value in accepted, f"{message}: expected one of {accepted}, got {value}"

    def get_node_db_rows():
        return json.loads(machine.succeed(
            "curl -sf --max-time 5 -X POST http://localhost:9266/api/v2/cruddb "
            "-H 'Content-Type: application/json' "
            "--data '{\"data\":{\"collection\":\"NodeJSONDB\",\"mode\":\"getAll\"}}'"
        ))

    def wait_for_node_row(node_id, attempts=90, delay=1):
        rows = []
        node = None
        for _ in range(attempts):
            rows = get_node_db_rows()
            if isinstance(rows, list):
                node = next((v for v in rows if v.get("_id") == node_id), None)
            if node is not None:
                return node
            time.sleep(delay)
        raise AssertionError(f"node row not found for _id={node_id}; rows={rows}")

    machine.wait_for_unit("tdarr-server.service")
    machine.wait_for_unit("tdarr-node-main.service")

    with subtest("disabled node should not have a service"):
        machine.fail("systemctl is-enabled tdarr-node-secondary.service")

    with subtest("data directories created with correct ownership"):
        machine.succeed("test -d /var/lib/tdarr")
        machine.succeed("stat -c '%U:%G' /var/lib/tdarr | grep -q 'tdarr:tdarr'")

    with subtest("disabled node directory should not exist"):
        machine.fail("test -d /var/lib/tdarr/nodes/secondary")

    with subtest("server environment variables are set correctly"):
        env = machine.succeed("systemctl show tdarr-server.service --property=Environment")
        assert "serverPort=9266" in env, f"serverPort not found in: {env}"
        assert "webUIPort=9265" in env, f"webUIPort not found in: {env}"
        assert "serverIP=0.0.0.0" in env, f"serverIP not found in: {env}"
        assert "serverBindIP=false" in env, f"serverBindIP not found in: {env}"
        assert "serverDualStack=false" in env, f"serverDualStack not found in: {env}"
        assert "openBrowser=false" in env, f"openBrowser not found in: {env}"
        assert "auth=false" in env, f"auth not found in: {env}"
        assert "maxLogSizeMB=10" in env, f"maxLogSizeMB not found in: {env}"
        assert "cronPluginUpdate=" in env, f"cronPluginUpdate not found in: {env}"

    with subtest("node environment variables are set correctly"):
        env = machine.succeed("systemctl show tdarr-node-main.service --property=Environment")
        assert "serverURL=http://127.0.0.1:9266" in env, f"serverURL not found in: {env}"
        assert "serverIP=127.0.0.1" in env, f"serverIP not found in: {env}"
        assert "serverPort=9266" in env, f"serverPort not found in: {env}"
        assert "nodeType=mapped" in env, f"nodeType not found in: {env}"
        assert "priority=7" in env, f"priority not found in: {env}"
        assert "pollInterval=4321" in env, f"pollInterval not found in: {env}"
        assert "startPaused=false" in env, f"startPaused not found in: {env}"
        assert "maxLogSizeMB=42" in env, f"maxLogSizeMB not found in: {env}"
        assert "cronPluginUpdate=*/15 * * * *" in env, f"cronPluginUpdate not found in: {env}"
        assert "transcodecpuWorkers=3" in env, f"transcodecpuWorkers not found in: {env}"
        assert "healthcheckcpuWorkers=2" in env, f"healthcheckcpuWorkers not found in: {env}"
        assert "transcodegpuWorkers=1" in env, f"transcodegpuWorkers not found in: {env}"
        assert "healthcheckgpuWorkers=1" in env, f"healthcheckgpuWorkers not found in: {env}"

    with subtest("custom ports are listening"):
        machine.wait_for_open_port(9265)
        machine.wait_for_open_port(9266)

    with subtest("server reports healthy status"):
        status = json.loads(machine.succeed("curl -sf --max-time 5 http://localhost:9266/api/v2/status"))
        assert "version" in status, f"version missing from status: {status}"
        assert status.get("uptime", -1) >= 0, f"unexpected uptime in status: {status}"

    with subtest("web UI serves HTML"):
        html = machine.succeed("curl --fail http://localhost:9265/")
        assert "<!DOCTYPE html>" in html or "<html" in html, f"web UI did not return HTML: {html[:200]}"

    with subtest("node reconnect and config-sync service succeed"):
        machine.succeed("systemctl restart tdarr-node-main.service")
        machine.succeed("systemctl start tdarr-node-config-main.service")
        machine.succeed("systemctl show tdarr-node-config-main.service -p Result --value | grep -q '^success$'")
        machine.succeed("systemctl show tdarr-node-config-main.service -p ExecMainStatus --value | grep -q '^0$'")
        journal = machine.succeed("journalctl -u tdarr-node-config-main.service --no-pager -o cat")
        assert "Tdarr node config sync: waiting for server at http://127.0.0.1:9266" in journal, f"missing wait log: {journal}"
        assert "Tdarr node config sync: updating NodeJSONDB for tdarr-main-custom" in journal, f"missing update log: {journal}"
        assert "Tdarr node config sync: merged desired values into /var/lib/tdarr/nodes/main/configs/Tdarr_Node_Config.json" in journal, f"missing merge log: {journal}"
        assert "pathTranslators" in journal, f"missing pathTranslators log key: {journal}"
        assert "/mnt/server/cache" in journal and "/mnt/node/cache" in journal, f"missing cache path translation log: {journal}"
        assert "/mnt/server/media" in journal and "/mnt/node/media" in journal, f"missing media path translation log: {journal}"

    with subtest("node JSON config file contains configured values"):
      cfg = json.loads(machine.succeed("cat /var/lib/tdarr/nodes/main/configs/Tdarr_Node_Config.json"))
      assert cfg.get("nodeName") == "tdarr-main-custom", f"unexpected nodeName in config JSON: {cfg}"
      assert cfg.get("nodeType") == "mapped", f"unexpected nodeType in config JSON: {cfg}"
      assert cfg.get("serverURL") == "http://127.0.0.1:9266", f"unexpected serverURL in config JSON: {cfg}"
      assert cfg.get("serverIP") == "127.0.0.1", f"unexpected serverIP in config JSON: {cfg}"
      assert_any(cfg.get("serverPort"), [9266, "9266"], f"unexpected serverPort in config JSON: {cfg}")
      assert cfg.get("priority") == 7, f"unexpected priority in config JSON: {cfg}"
      assert cfg.get("pollInterval") == 4321, f"unexpected pollInterval in config JSON: {cfg}"
      assert cfg.get("startPaused") == False, f"unexpected startPaused in config JSON: {cfg}"
      assert_any(cfg.get("maxLogSizeMB"), [42, "42"], f"unexpected maxLogSizeMB in config JSON: {cfg}")
      assert cfg.get("cronPluginUpdate") == "*/15 * * * *", f"unexpected cronPluginUpdate in config JSON: {cfg}"
      assert cfg.get("pathTranslators") == [
        {"server": "/mnt/server/cache", "node": "/mnt/node/cache"},
        {"server": "/mnt/server/media", "node": "/mnt/node/media"},
      ], f"unexpected pathTranslators in config JSON: {cfg}"

    with subtest("node config is persisted via API in NodeJSONDB"):
        node = wait_for_node_row("tdarr-main-custom")

        node_worker_limits = node.get("workerLimits", {})
        assert node_worker_limits.get("transcodecpu") == 3, f"unexpected transcodecpu worker count: {node}"
        assert node_worker_limits.get("healthcheckcpu") == 2, f"unexpected healthcheckcpu worker count: {node}"
        assert node_worker_limits.get("transcodegpu") == 1, f"unexpected transcodegpu worker count: {node}"
        assert node_worker_limits.get("healthcheckgpu") == 1, f"unexpected healthcheckgpu worker count: {node}"

        assert node.get("_id") == "tdarr-main-custom", f"unexpected node _id: {node}"
        assert node.get("nodeTags") == "mapped", f"unexpected nodeTags: {node}"
        assert node.get("priority") == 7, f"unexpected priority: {node}"
        assert node.get("nodePaused") == False, f"unexpected nodePaused: {node}"
  '';
}
