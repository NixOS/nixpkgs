{ lib, pkgs, ... }:
let
  agent_host = "agent.test";
  dashboard_host = "dashboard.test";

  agentSecret = pkgs.writeText "fakeagentsecret" "fakeagentsecret";

  hosts = {
    "${agent_host}" = "192.168.0.2";
    "${dashboard_host}" = "192.168.0.1";
  };
  hostsEntries = lib.mapAttrs' (k: v: {
    name = v;
    value = lib.singleton k;
  }) hosts;
in
{
  name = "nezha";

  meta = {
    maintainers = with lib.maintainers; [ moraxyc ];
  };

  nodes = {
    agent =
      { ... }:
      {
        networking = {
          hostName = builtins.elemAt (lib.splitString "." agent_host) 0;
          domain = builtins.elemAt (lib.splitString "." agent_host) 1;
          firewall.enable = false;
          hosts = hostsEntries;
          useDHCP = false;
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = hosts."${agent_host}";
                prefixLength = 24;
              }
            ];
          };
        };
        services.nezha-agent = {
          enable = true;
          debug = true;
          genUuid = true;
          settings = {
            server = hosts."${dashboard_host}" + ":80";
          };
          clientSecretFile = agentSecret;
        };
      };

    dashboard =
      { pkgs, ... }:
      {
        networking = {
          firewall.enable = false;
          hosts = hostsEntries;
          useDHCP = false;
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = hosts."${dashboard_host}";
                prefixLength = 24;
              }
            ];
          };
        };
        services.nezha = {
          enable = true;
          debug = true;
          settings = {
            listenhost = "0.0.0.0";
            # Test CAP_NET_BIND_SERVICE
            listenport = 80;
          };
          mutableConfig = true;
          jwtSecretFile = pkgs.writeText "fakejwt" "fakejwt";
          agentSecretFile = agentSecret;
        };
      };
  };

  testScript = ''
    import json

    # Services
    dashboard.wait_for_unit("nezha.service")
    agent.wait_for_unit("nezha-agent.service")
    dashboard.wait_for_open_port(80)

    # Network
    dashboard.wait_for_unit("network.target")
    agent.wait_for_unit("network.target")

    # Ping
    agent.succeed("curl --fail --max-time 10 http://dashboard.test/")

    # Test mutableConfig
    dashboard.succeed("systemctl stop nezha")
    dashboard.succeed("""
      echo '{"sitename": "Nezha on NixOS"}' > /etc/nezha/config.yaml
    """)
    dashboard.succeed("systemctl start nezha")
    dashboard.wait_for_unit("nezha.service")
    dashboard.wait_for_open_port(80)

    # Get token
    result = json.loads(agent.succeed("""
        curl --fail -X POST --json '{ "username": "admin", "password": "admin"}' \
          'http://dashboard.test/api/v1/login'
    """))
    token = result['data']['token']

    # Verify siteName
    result = json.loads(agent.succeed(f"""
      curl --fail -X GET --header 'Authorization: Bearer {token}' \
        'http://dashboard.test/api/v1/setting'
    """))
    assert "Nezha on NixOS" == result['data']['config']['site_name']

    # Verify connection and uuid
    uuid = agent.succeed(
        "${lib.getExe' pkgs.util-linux "uuidgen"} --md5 -n @dns -N ${agent_host}"
    )
    # remove unprintable characters
    uuid = "".join([char for char in uuid if char.isprintable()])
    agent.wait_until_succeeds(f"""
      curl --fail -X GET --header 'Authorization: Bearer {token}' \
        'http://dashboard.test/api/v1/server' | grep {uuid}
    """)
  '';
}
