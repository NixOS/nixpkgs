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
            type = "mapped";
            priority = -1;
            pollInterval = 2000;
            startPaused = false;
            maxLogSizeMB = 10;
            workers = {
              transcodeCPU = 1;
              healthcheckCPU = 1;
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
        env = machine.succeed(
            "systemctl show tdarr-server.service --property=Environment"
        )
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
        env = machine.succeed(
            "systemctl show tdarr-node-main.service --property=Environment"
        )
        assert "serverURL=http://127.0.0.1:9266" in env, f"serverURL not found in: {env}"
        assert "nodeType=mapped" in env, f"nodeType not found in: {env}"
        assert "priority=-1" in env, f"priority not found in: {env}"
        assert "pollInterval=2000" in env, f"pollInterval not found in: {env}"
        assert "startPaused=false" in env, f"startPaused not found in: {env}"
        assert "maxLogSizeMB=10" in env, f"maxLogSizeMB not found in: {env}"
        assert "transcodecpuWorkers=1" in env, f"transcodecpuWorkers not found in: {env}"
        assert "healthcheckcpuWorkers=1" in env, f"healthcheckcpuWorkers not found in: {env}"
        assert "transcodegpuWorkers=0" in env, f"transcodegpuWorkers not found in: {env}"
        assert "healthcheckgpuWorkers=0" in env, f"healthcheckgpuWorkers not found in: {env}"

    with subtest("custom ports are listening"):
        machine.wait_for_open_port(9265)
        machine.wait_for_open_port(9266)

    with subtest("server reports healthy status"):
        status = json.loads(machine.succeed("curl -sf http://localhost:9266/api/v2/status"))
        assert "version" in status, f"version missing from status: {status}"
        assert status.get("uptime", -1) >= 0, f"unexpected uptime in status: {status}"

    with subtest("web UI serves HTML"):
        html = machine.succeed("curl --fail http://localhost:9265/")
        assert "<!DOCTYPE html>" in html or "<html" in html, f"web UI did not return HTML: {html[:200]}"

    with subtest("node registers with server and reports correct config"):
        machine.wait_until_succeeds(
            "curl -sf http://localhost:9266/api/v2/get-nodes | grep -q 'main'"
        )
        response = machine.succeed("curl -sf http://localhost:9266/api/v2/get-nodes")
        nodes = json.loads(response)
        node = next((v for v in nodes.values() if "main" in v.get("nodeName", "")), None)
        assert node is not None, f"node 'main' not found in: {nodes}"
        node_config = node["config"]
        node_worker_limits = node["workerLimits"]

        # Worker limits
        assert node_worker_limits.get("transcodecpu") == 1, f"unexpected transcodecpu worker count: {node}"
        assert node_worker_limits.get("healthcheckcpu") == 1, f"unexpected healthcheckcpu worker count: {node}"
        assert node_worker_limits.get("transcodegpu") == 0, f"unexpected transcodegpu worker count: {node}"
        assert node_worker_limits.get("healthcheckgpu") == 0, f"unexpected healthcheckgpu worker count: {node}"

        # Node config as registered with the server
        assert "pathTranslators" in node_config, f"pathTranslators missing from node config: {node_config}"
        assert node_config.get("nodeType") == "mapped", f"unexpected nodeType: {node_config}"
        assert node_config.get("priority") == -1, f"unexpected priority: {node_config}"
        assert node_config.get("pollInterval") == 2000, f"unexpected pollInterval: {node_config}"
        assert node_config.get("startPaused") == False, f"unexpected startPaused: {node_config}"
        assert node_config.get("maxLogSizeMB") == "10", f"unexpected maxLogSizeMB: {node_config}"
        assert node_config.get("cronPluginUpdate") == "", f"unexpected cronPluginUpdate: {node_config}"

        # Top-level node state
        assert node.get("nodePaused") == False, f"unexpected nodePaused: {node}"
        assert node.get("nodeTags") == "mapped", f"unexpected nodeTags: {node}"
  '';
}
