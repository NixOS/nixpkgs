# Test Docker containers as systemd units

import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "docker-containers";
  meta = {
    maintainers = with lib.maintainers; [ benley mkaito ];
  };

  nodes = {
    docker = { pkgs, ... }: {
      virtualisation.docker.enable = true;

      docker-containers.nginx = {
        image = "nginx-container";
        imageFile = pkgs.dockerTools.examples.nginx;
        ports = ["8181:80"];
      };
    };
  };

  testScript = ''
    start_all()
    docker.wait_for_unit("docker-nginx.service")
    docker.wait_for_open_port(8181)
    docker.wait_until_succeeds("curl http://localhost:8181 | grep Hello")
  '';
})
