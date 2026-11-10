{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "plakar-plugin-sftp";
  version = "1.1.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "integrations";
    tag = "sftp/v${finalAttrs.version}";
    hash = "sha256-sGzIzHDxWW2htnA6xpZDDJ0a4+8fQQmScswFNQqmkRY=";
  };

  vendorHash = "sha256-zfvvax8cO0fqOxgBGn1pEpD+FbBGONwy+87GgzK75J8=";

  sourceRoot = "${finalAttrs.src.name}/sftp";

  subPackages = [
    "plugin/importer"
    "plugin/exporter"
    "plugin/storage"
  ];

  postInstall = ''
    dest="$out/share/plakar/plugins/v1.1.0/sftp_v${finalAttrs.version}_$(go env GOOS)_$(go env GOARCH)"
    mkdir -p "$dest"
    install -m0644 manifest.yaml "$dest/manifest.yaml"
    mv "$out/bin/importer" "$dest/sftpImporter"
    mv "$out/bin/exporter" "$dest/sftpExporter"
    mv "$out/bin/storage" "$dest/sftpStorage"
    rmdir "$out/bin" 2>/dev/null || true
  '';

  meta = {
    description = "Plakar SFTP integration (storage, importer, exporter)";
    homepage = "https://github.com/PlakarKorp/integrations";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
