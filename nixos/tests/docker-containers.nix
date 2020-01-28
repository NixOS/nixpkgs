# Test Docker containers as systemd units

import ./make-test.nix ({ pkgs, lib, ... }:

{
  name = "docker-containers";
  meta = {
    maintainers = with lib.maintainers; [ benley mkaito ];
  };

  nodes = {
    docker = { pkgs, ... }:
      {
        virtualisation.docker.enable = true;

        docker-containers.nginx = {
          image = "nginx-container";
          imageFile = pkgs.dockerTools.examples.nginx;
          ports = ["8181:80"];
        };
      };
  };

  testScript = ''
    startAll;
    $docker->waitForUnit("docker-nginx.service");
    $docker->waitForOpenPort(8181);
    $docker->waitUntilSucceeds("curl http://localhost:8181|grep Hello");
  '';
})
