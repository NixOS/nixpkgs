# verifies:
#   1. GoCD agent starts
#   2. GoCD agent responds
#   3. GoCD agent is available on GoCD server using GoCD API
#     3.1. https://api.go.cd/current/#get-all-agents

import ./make-test.nix ({ pkgs, ...} : {
  name = "gocd-agent";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ swarren83 ];
  };

nodes = {
  gocd_agent =
    { config, pkgs, ... }:
    { 
      virtualisation.memorySize = 2048;
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
    $gocd_agent->waitUntilSucceeds("curl -s -f localhost:8153/go/api/agents -H 'Accept: application/vnd.go.cd.v2+json'");
  '';
})
