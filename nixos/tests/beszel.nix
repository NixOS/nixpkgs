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
      };
  };

  testScript =
    { nodes, ... }:
    let
      hubCfg = nodes.hubHost.services.beszel.hub;
      agentCfg = nodes.agentHost.specialisation."agent".configuration.services.beszel.agent;
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
            "users" = ''{user['record']['id']}'';
          }
        }}\' "${agentCfg.environment.HUB_URL}/api/collections/systems/records"')

      with subtest("Start agent"):
        agentHost.succeed("/run/current-system/specialisation/agent/bin/switch-to-configuration switch")
        agentHost.wait_for_unit("beszel-agent.service")
        agentHost.wait_until_succeeds("journalctl -eu beszel-agent --grep 'SSH connection established'")
        agentHost.wait_until_succeeds(f'curl -H \'Authorization: {user["token"]}\' -f ${agentCfg.environment.HUB_URL}/api/collections/systems/records | grep agentHost')
    '';
}
