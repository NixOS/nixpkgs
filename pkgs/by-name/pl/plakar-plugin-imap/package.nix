{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "plakar-plugin-imap";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "integrations";
    tag = "imap/v${finalAttrs.version}";
    hash = "sha256-qjHNitOT7Qkb3FGlDICWs3y+hVCTVORINabKa3yIQJs=";
  };

  vendorHash = "sha256-f6AAGhjVfqCr89Qr7es4AODjAMruzHOuWjz8DPA4TW8=";

  sourceRoot = "${finalAttrs.src.name}/imap";

  subPackages = [
    "plugin/importer"
    "plugin/exporter"
    "plugin/store"
  ];

  postInstall = ''
    dest="$out/share/plakar/plugins/v1.1.0/imap_v${finalAttrs.version}_$(go env GOOS)_$(go env GOARCH)"
    mkdir -p "$dest"
    install -m0644 manifest.yaml "$dest/manifest.yaml"
    mv "$out/bin/importer" "$dest/imapImporter"
    mv "$out/bin/exporter" "$dest/imapExporter"
    mv "$out/bin/store" "$dest/imapStorage"
    rmdir "$out/bin" 2>/dev/null || true
  '';

  meta = {
    description = "Plakar IMAP integration (storage, importer, exporter)";
    homepage = "https://github.com/PlakarKorp/integrations";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
