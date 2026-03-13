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
        assert "openBrowser=false" in env, f"openBrowser not found in: {env}"
        assert "auth=false" in env, f"auth not found in: {env}"

    with subtest("node environment variables are set correctly"):
        env = machine.succeed(
            "systemctl show tdarr-node-main.service --property=Environment"
        )
        assert "serverURL=http://127.0.0.1:9266" in env, f"serverURL not found in: {env}"
        assert "transcodecpuWorkers=1" in env, f"transcodecpuWorkers not found in: {env}"
        assert "healthcheckcpuWorkers=1" in env, f"healthcheckcpuWorkers not found in: {env}"

    with subtest("node config JSON is correct"):
        import json
        config = machine.succeed(
            "cat /var/lib/tdarr/nodes/main/configs/Tdarr_Node_Config.json"
        )
        data = json.loads(config)
        assert "pathTranslators" in data, f"pathTranslators missing from config: {data}"

    with subtest("custom ports are listening"):
        machine.wait_for_open_port(9265)
        machine.wait_for_open_port(9266)

    with subtest("server reports healthy status"):
        import json
        status = json.loads(machine.succeed("curl -sf http://localhost:9266/api/v2/status"))
        assert "version" in status, f"version missing from status: {status}"
        assert status.get("uptime", -1) >= 0, f"unexpected uptime in status: {status}"

    with subtest("web UI serves HTML"):
        html = machine.succeed("curl --fail http://localhost:9265/")
        assert "<!DOCTYPE html>" in html or "<html" in html, f"web UI did not return HTML: {html[:200]}"

    with subtest("node registers with server and reports correct worker counts"):
        import json
        machine.wait_until_succeeds(
            "curl -sf http://localhost:9266/api/v2/get-nodes | grep -q 'main'"
        )
        response = machine.succeed("curl -sf http://localhost:9266/api/v2/get-nodes")
        nodes = json.loads(response)
        node = next((v for v in nodes.values() if "main" in v.get("nodeName", "")), None)
        assert node is not None, f"node 'main' not found in: {nodes}"
        assert node.get("workerLimits", {}).get("transcodecpu") == 1, f"unexpected transcodecpu worker count: {node}"
        assert node.get("workerLimits", {}).get("healthcheckcpu") == 1, f"unexpected healthcheckcpu worker count: {node}"
  '';
}
