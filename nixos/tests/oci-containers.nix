{ config, lib, backend, ... }:
{
  name = "oci-containers-${backend}";

  meta = {
    maintainers = with lib.maintainers; [ adisbladis benley ] ++ lib.teams.serokell.members;
  };

  matrix.backend.choice.docker.module = {};
  matrix.backend.choice.podman.module = {};

  nodes = {
    ${backend} = { pkgs, ... }: {
      virtualisation.oci-containers = {
        inherit backend;
        containers.nginx = {
          image = "nginx-container";
          imageFile = pkgs.dockerTools.examples.nginx;
          ports = [ "8181:80" ];
        };
      };
    };
  };

  testScript = ''
    start_all()
    ${backend}.wait_for_unit("${backend}-nginx.service")
    ${backend}.wait_for_open_port(8181)
    ${backend}.wait_until_succeeds("curl -f http://localhost:8181 | grep Hello")
  '';
}
