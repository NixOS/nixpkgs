{ pkgs, lib, ... }:
{
  name = "beszel";
  meta.maintainers = with lib.maintainers; [ h7x4 ];

  nodes = {
    hubHost =
      { config, pkgs, ... }:
      {
        virtualisation.vlans = [ 1 ];

        systemd.network.networks."01-eth1" = {
          name = "eth1";
          networkConfig.Address = "10.0.0.1/24";
        };

        networking = {
          useNetworkd = true;
          useDHCP = false;
        };

        services.beszel.hub = {
          enable = true;
          host = "10.0.0.1";
        };

        networking.firewall.allowedTCPPorts = [
          config.services.beszel.hub.port
        ];

        environment.systemPackages = [
          config.services.beszel.hub.package
        ];
      };

    agentHost =
      { config, pkgs, ... }:
      {
        virtualisation.vlans = [ 1 ];

        systemd.network.networks."01-eth1" = {
          name = "eth1";
          networkConfig.Address = "10.0.0.2/24";
        };

        networking = {
          useNetworkd = true;
          useDHCP = false;
        };

        environment.systemPackages = with pkgs; [ jq ];

        specialisation."agent".configuration = {
          services.beszel.agent = {
            enable = true;
            environment.HUB_URL = "http://10.0.0.1:8090";
            environment.KEY_FILE = "/var/lib/beszel-agent/id_ed25519.pub";
            environment.TOKEN_FILE = "/var/lib/beszel-agent/token";
            openFirewall = true;
          };
        };

        # Only inspected by the test script, never activated: the VM has no GPU,
        # but the generated units can still be checked.
        specialisation."gpu-sysfs".configuration = {
          services.beszel.agent = {
            enable = true;
            environment.GPU_COLLECTOR = [ "amd_sysfs" ];
          };
        };

        specialisation."gpu-devices".configuration = {
          services.beszel.agent = {
            enable = true;
            environment.GPU_COLLECTOR = [ "intel_gpu_top" ];
          };
        };

        specialisation."gpu-smartmon".configuration = {
          services.beszel.agent = {
            enable = true;
            # upstream's comma-separated form is accepted as well
            environment.GPU_COLLECTOR = "intel_gpu_top";
            smartmon = {
              enable = true;
              deviceAllow = [ "/dev/nvme0" ];
            };
          };
        };

        specialisation."gpu-skipped".configuration = {
          services.beszel.agent = {
            enable = true;
            environment = {
              SKIP_GPU = true;
              GPU_COLLECTOR = [ "intel_gpu_top" ];
            };
          };
        };
      };
  };

  testScript =
    { nodes, ... }:
    let
      hubCfg = nodes.hubHost.services.beszel.hub;
      agentCfg = nodes.agentHost.specialisation."agent".configuration.services.beszel.agent;
      # /run/current-system points at the "agent" specialisation after the switch,
      # so the units are read from the store directly.
      gpuUnit =
        name:
        "${
          nodes.agentHost.specialisation.${name}.configuration.system.build.toplevel
        }/etc/systemd/system/beszel-agent.service";
    in
    ''
      import json

      start_all()

      with subtest("Start hub"):
        hubHost.wait_for_unit("beszel-hub.service")
        hubHost.wait_for_open_port(${toString hubCfg.port}, "${toString hubCfg.host}")

      with subtest("Register user"):
        agentHost.succeed('curl -f --json \'${
          builtins.toJSON {
            email = "admin@example.com";
            password = "password";
          }
        }\' "${agentCfg.environment.HUB_URL}/api/beszel/create-user"')
        user = json.loads(agentHost.succeed('curl -f --json \'${
          builtins.toJSON {
            identity = "admin@example.com";
            password = "password";
          }
        }\' ${agentCfg.environment.HUB_URL}/api/collections/users/auth-with-password').strip())

      with subtest("Install agent credentials"):
        agentHost.succeed("mkdir -p \"$(dirname '${agentCfg.environment.KEY_FILE}')\" \"$(dirname '${agentCfg.environment.TOKEN_FILE}')\"")
        sshkey = agentHost.succeed(f"curl -H 'Authorization: {user["token"]}' -f ${agentCfg.environment.HUB_URL}/api/beszel/getkey | jq -r .key").strip()
        utoken = agentHost.succeed(f"curl -H 'Authorization: {user["token"]}' -f ${agentCfg.environment.HUB_URL}/api/beszel/universal-token | jq -r .token").strip()
        agentHost.succeed(f"echo '{sshkey}' > '${agentCfg.environment.KEY_FILE}'")
        agentHost.succeed(f"echo '{utoken}' > '${agentCfg.environment.TOKEN_FILE}'")

      with subtest("Register agent in hub"):
        agentHost.succeed(f'curl -H \'Authorization: {user["token"]}\' -f --json \'{${
          builtins.toJSON {
            "host" = "10.0.0.2";
            "name" = "agent";
            "pkey" = "{sshkey}";
            "port" = "45876";
            "tkn" = "{utoken}";
            "users" = "{user['record']['id']}";
          }
        }}\' "${agentCfg.environment.HUB_URL}/api/collections/systems/records"')

      with subtest("Start agent"):
        agentHost.succeed("/run/current-system/specialisation/agent/bin/switch-to-configuration switch")
        agentHost.wait_for_unit("beszel-agent.service")
        agentHost.wait_until_succeeds("journalctl -eu beszel-agent --grep 'SSH connection established'")
        agentHost.wait_until_succeeds(f'curl -H \'Authorization: {user["token"]}\' -f ${agentCfg.environment.HUB_URL}/api/collections/systems/records | jq -e \'.items[].status == "up"\' ')

      with subtest("Agent stays sandboxed without a GPU"):
        agentHost.succeed("systemctl show beszel-agent -p PrivateDevices --value | grep -qx yes")
        agentHost.succeed("systemctl show beszel-agent -p PrivateUsers --value | grep -qx yes")

      with subtest("GPU collectors shape the unit"):
        # sysfs-only collector keeps the sandbox
        sysfs = agentHost.succeed("cat ${gpuUnit "gpu-sysfs"}")
        assert "PrivateDevices=true" in sysfs, sysfs
        assert "PrivateUsers=true" in sysfs, sysfs
        assert "intel-gpu-tools" not in sysfs, sysfs

        # device-based collector gets its devices as an allow-list, and
        # CAP_PERFMON/perf_event_open with the user namespace disabled
        devices = agentHost.succeed("cat ${gpuUnit "gpu-devices"}")
        assert "PrivateDevices=false" in devices, devices
        assert "PrivateUsers=false" in devices, devices
        assert "DeviceAllow=char-drm rw" in devices, devices
        assert "CAP_PERFMON" in devices, devices
        assert "perf_event_open" in devices, devices

        # GPU devices must survive smartmon's DeviceAllow list
        smartmon = agentHost.succeed("cat ${gpuUnit "gpu-smartmon"}")
        assert "DeviceAllow=/dev/nvme0 r" in smartmon, smartmon
        assert "DeviceAllow=char-drm rw" in smartmon, smartmon

        # SKIP_GPU wins over an explicitly configured collector
        skipped = agentHost.succeed("cat ${gpuUnit "gpu-skipped"}")
        assert "PrivateDevices=true" in skipped, skipped
        assert "intel-gpu-tools" not in skipped, skipped
    '';
}
