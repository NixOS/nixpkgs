{ pkgs, ... }:
{
  name = "umap-port-based";

  meta.maintainers = pkgs.umap.meta.maintainers;

  nodes.machine =
    { ... }:
    {
      services.umap = {
        enable = true;
        port = 8080;
        host = "127.0.0.1";
        settings = {
          SITE_URL = "http://localhost";
          UMAP_ALLOW_ANONYMOUS = true;
        };
        nginx.enable = true;
      };
    };

  testScript = ''
    import json

    machine.wait_for_unit("umap.service")
    machine.wait_for_unit("nginx.service")

    machine.wait_for_open_port(80)
    machine.wait_for_open_port(8080)

    with subtest("Umap listens on HTTP port 8080"):
        machine.succeed("curl -sSfL http://localhost:8080/ | grep -i umap")

    with subtest("Nginx proxies to port-based backend"):
        machine.succeed("curl -sSfL http://localhost/ | grep -i umap")
  '';
}
