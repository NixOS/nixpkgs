{ pkgs, ... }:
{
  name = "umap-port-based";

  meta.maintainers = pkgs.umap.meta.maintainers;

  nodes.machine =
    { ... }:
    {
      services.umap = {
        enable = true;
        # Deliberately privileged: this is the only configuration in which the
        # service keeps CAP_NET_BIND_SERVICE and runs without PrivateUsers.
        port = 81;
        settings.SITE_URL = "http://localhost";
      };
    };

  testScript = ''
    machine.wait_for_unit("umap.service")
    machine.wait_for_unit("nginx.service")

    machine.wait_for_open_port(80)
    machine.wait_for_open_port(81)

    with subtest("Umap binds the privileged port itself"):
        machine.wait_until_succeeds("curl -sSfL http://localhost:81/ | grep -i umap")

    with subtest("Nginx proxies to the port-based backend"):
        machine.succeed("curl -sSfL http://localhost/ | grep -i umap")
  '';
}
