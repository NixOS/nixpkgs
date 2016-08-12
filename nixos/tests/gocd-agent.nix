# verifies:
#   1. GoCD agent starts
#   2. GoCD agent responds
#   3. GoCD agent is available on GoCD server using GoCD API
#     3.1. https://api.go.cd/current/#get-all-agents

let
  serverUrl = "localhost:8153/go/api/agents";
  header = "Accept: application/vnd.go.cd.v2+json";
in

import ./make-test.nix ({ pkgs, ...} : {
  name = "gocd-agent";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ grahamc swarren83 ];
  };

  nodes = {
    gocd_agent =
      { config, pkgs, ... }:
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
    startAll;
    $gocd_agent->waitForUnit("gocd-server");
    $gocd_agent->waitForOpenPort("8153");
    $gocd_agent->waitForUnit("gocd-agent");
    $gocd_agent->waitUntilSucceeds("curl ${serverUrl} -H '${header}' | ${pkgs.jq}/bin/jq -e ._embedded.agents[0].uuid");
    $gocd_agent->succeed("curl ${serverUrl} -H '${header}' | ${pkgs.jq}/bin/jq -e ._embedded.agents[0].agent_state | grep -q Idle");
  '';
})
