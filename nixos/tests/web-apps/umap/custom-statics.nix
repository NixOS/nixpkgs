{ pkgs, ... }:
let
  customStatics = pkgs.writeTextDir "custom/test-custom.css" "body { color: red; }";
in
{
  name = "umap-custom-statics";

  meta.maintainers = pkgs.umap.meta.maintainers;

  nodes.machine =
    { ... }:
    {
      services.umap = {
        enable = true;
        settings = {
          SITE_URL = "http://localhost";
          UMAP_ALLOW_ANONYMOUS = true;
          UMAP_CUSTOM_STATICS = "${customStatics}";
        };
      };
    };

  testScript =
    { nodes, ... }:
    let
      staticRoot = nodes.machine.systemd.services.umap.environment.STATIC_ROOT;
    in
    ''
      import json

      machine.wait_for_unit("umap.service")
      machine.wait_for_unit("nginx.service")
      machine.wait_for_open_port(80)
      machine.wait_for_file("/run/umap/umap.sock")

      with subtest("Umap web interface is accessible"):
          machine.succeed("curl -sSfL http://localhost/ | grep -i umap")

      manifest = json.loads(machine.succeed("cat ${staticRoot}/staticfiles.json"))

      with subtest("Default static files are served"):
          machine.succeed("curl -sSfL http://localhost/static/" + manifest["paths"]["umap/base.css"])

      with subtest("Custom static file is served"):
          machine.succeed("curl -sSfL http://localhost/static/" + manifest["paths"]["custom/test-custom.css"])
    '';
}
