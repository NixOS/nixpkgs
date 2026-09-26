{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "plakar-plugin-ftp";
  version = "1.1.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "integrations";
    tag = "ftp/v${finalAttrs.version}";
    hash = "sha256-z+3t8ODXwjmUbTGvC3ZojQWHpyBVYzOuPahp2e58/DE=";
  };

  vendorHash = "sha256-r58IZ8Y2gf1Uot3AyHDJXNJx+1T8PK25801sA1GKyDs=";

  sourceRoot = "${finalAttrs.src.name}/ftp";

  subPackages = [
    "plugin/importer"
    "plugin/exporter"
  ];

  postInstall = ''
    dest="$out/share/plakar/plugins/v1.1.0/ftp_v${finalAttrs.version}_$(go env GOOS)_$(go env GOARCH)"
    mkdir -p "$dest"
    install -m0644 manifest.yaml "$dest/manifest.yaml"
    mv "$out/bin/importer" "$dest/ftpImporter"
    mv "$out/bin/exporter" "$dest/ftpExporter"
    rmdir "$out/bin" 2>/dev/null || true
  '';

  meta = {
    description = "Plakar FTP integration (importer, exporter)";
    homepage = "https://github.com/PlakarKorp/integrations";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
