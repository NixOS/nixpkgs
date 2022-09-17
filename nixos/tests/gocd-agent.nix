# verifies:
#   1. GoCD agent starts
#   2. GoCD agent responds
#   3. GoCD agent is available on GoCD server using GoCD API
#     3.1. https://api.go.cd/current/#get-all-agents

let
  serverUrl = "localhost:8153/go/api/agents";
  header = "Accept: application/vnd.go.cd.v2+json";
in

import ./make-test-python.nix ({ pkgs, ...} : {
  name = "gocd-agent";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ grahamc swarren83 ];

    # gocd agent needs to register with the autoregister key created on first server startup,
    # but NixOS module doesn't seem to allow to pass during runtime currently
    broken = true;
  };

  nodes = {
    agent =
      { ... }:
      {
        virtualisation.memorySize = 2046;
        services.gocd-agent = {
          enable = true;
        };
        services.gocd-server = {
          enable = true;
        };
      };
  };

  testScript = ''
    start_all()
    agent.wait_for_unit("gocd-server")
    agent.wait_for_open_port(8153)
    agent.wait_for_unit("gocd-agent")
    agent.wait_until_succeeds(
        "curl ${serverUrl} -H '${header}' | ${pkgs.jq}/bin/jq -e ._embedded.agents[0].uuid"
    )
    agent.succeed(
        "curl ${serverUrl} -H '${header}' | ${pkgs.jq}/bin/jq -e ._embedded.agents[0].agent_state | grep Idle"
    )
  '';
})
