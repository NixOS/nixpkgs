{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "plakar-plugin-rclone";
  version = "1.1.0-beta.10";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "integrations";
    tag = "rclone/v${finalAttrs.version}";
    hash = "sha256-XSwUoXtfaKIY6oVYGqs05rJm7RC6oKGXHKS/6zdmzRQ=";
  };

  vendorHash = "sha256-w1BKzziY0imRLs8PYhId4jvwKZLd9dWJrohDYsGEvvg=";

  sourceRoot = "${finalAttrs.src.name}/rclone";

  subPackages = [
    "plugin/importer"
    "plugin/exporter"
    "plugin/storage"
  ];

  postInstall = ''
    dest="$out/share/plakar/plugins/v1.1.0/rclone_v${finalAttrs.version}_$(go env GOOS)_$(go env GOARCH)"
    mkdir -p "$dest"
    install -m0644 manifest.yaml "$dest/manifest.yaml"
    mv "$out/bin/importer" "$dest/rclone-importer"
    mv "$out/bin/exporter" "$dest/rclone-exporter"
    mv "$out/bin/storage" "$dest/rclone-storage"
    rmdir "$out/bin" 2>/dev/null || true
  '';

  meta = {
    description = "Plakar rclone integration (backup and restore via rclone remotes)";
    homepage = "https://github.com/PlakarKorp/integrations";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
