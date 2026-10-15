{ pkgs, ... }:
let
  pictograms = pkgs.runCommand "umap-test-pictograms" { } ''
    mkdir -p $out/pictograms/test
    printf 'pictogram-collection-ok' > $out/pictograms/test/marker.svg
  '';
  customStatics = pkgs.writeTextDir "custom/test-custom.css" "body { color: red; }";
in
{
  name = "umap-customize";

  meta.maintainers = pkgs.umap.meta.maintainers;

  nodes.machine =
    { ... }:
    {
      services.umap = {
        enable = true;
        settings = {
          SITE_URL = "http://localhost";
          SITE_NAME = "umap-from-settings";
          UMAP_PICTOGRAMS_COLLECTIONS.Test.path = "${pictograms}";
          UMAP_CUSTOM_STATICS = "${customStatics}";
        };
        extraConfig = ''
          SITE_NAME = "umap-from-extra-config"
        '';
      };
    };

  testScript = ''
    import re

    machine.wait_for_unit("umap.service")
    machine.wait_for_unit("nginx.service")

    machine.wait_for_open_port(80)
    machine.wait_until_succeeds("curl -sSfL http://localhost/ | grep -i umap")

    with subtest("extraConfig is appended after the settings"):
        page = machine.succeed("curl -sSfL http://localhost/")
        assert "umap-from-extra-config" in page
        assert "umap-from-settings" not in page

    with subtest("Custom static file is served through its manifest URL"):
        src = machine.succeed(
            "umap-manage shell -c \"from django.templatetags.static import static; "
            "print(static('custom/test-custom.css'))\""
        ).strip().splitlines()[-1]
        machine.succeed(f"curl -sSfL http://localhost{src} | grep -q red")

    # Umap lists the collection from its configured path, while the icons are
    # served from the static root this setting had to rebuild. Maps store the
    # URL of every icon they use, so a collection added here must not displace
    # the packaged one.
    with subtest("Pictogram collection is added next to the packaged one"):
        collections = machine.succeed("curl -sSfL http://localhost/pictogram/json/")
        assert "Osmic" in collections, "the packaged collection was replaced"
        src = re.search(r"/static/pictograms/test/[^\"]+", collections)
        assert src, f"the added collection is not listed in: {collections}"
        machine.succeed(f"curl -sSfL http://localhost{src.group(0)} | grep -q pictogram-collection-ok")
  '';
}
