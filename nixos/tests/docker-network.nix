# This test runs docker and checks if simple container starts

import ./make-test-python.nix ({ pkgs, ... }: {
  name = "docker-network";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ agentx3 ];
  };

  nodes = {
    docker_network =
      { pkgs, ... }:
      {
        virtualisation.docker.enable = true;
        virtualisation.docker.autoPrune.enable = true;
        virtualisation.docker.package = pkgs.docker;
        virtualisation.docker.networks = {
          "fooNetwork" = {
            enable = true;
            driver = "bridge";
            label = {
              foo = "bar";
            };
            subnet = [ "172.30.0.0/24" ];
          };
        };
      };
  };

  testScript = ''
    docker_network.start()
    docker_network.wait_for_unit("docker-network-fooNetwork.service")

    docker_network.succeed("${pkgs.docker}/bin/docker network ls | grep fooNetwork")
    docker_network.succeed("${pkgs.docker}/bin/docker network inspect fooNetwork | ${pkgs.jq}/bin/jq '.[0].Driver' | grep bridge")
    docker_network.succeed('[ $(${pkgs.docker}/bin/docker network inspect fooNetwork | ${pkgs.jq}/bin/jq -r \'.[0].IPAM.Config[0].Subnet\') = "172.30.0.0/24" ]')
  '';
})
