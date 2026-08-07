{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "plakar-plugin-gcs";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "integrations";
    tag = "gcs/v${finalAttrs.version}";
    hash = "sha256-aE2KJJ8dES3tkmDd15BXnP3JiUwmIgIEnNPbzoA8RrI=";
  };

  vendorHash = "sha256-bybNpbHKxZGapudUzUr2r7SiUUJNRQCuFJgZTziovuE=";

  sourceRoot = "${finalAttrs.src.name}/gcs";

  subPackages = [
    "importer"
    "exporter"
    "storage"
  ];

  postInstall = ''
    dest="$out/share/plakar/plugins/v1.1.0/gcs_v${finalAttrs.version}_$(go env GOOS)_$(go env GOARCH)"
    mkdir -p "$dest"
    install -m0644 manifest.yaml "$dest/manifest.yaml"
    mv "$out/bin/importer" "$dest/gcs-importer"
    mv "$out/bin/exporter" "$dest/gcs-exporter"
    mv "$out/bin/storage" "$dest/gcs-storage"
    rmdir "$out/bin" 2>/dev/null || true
  '';

  meta = {
    description = "Plakar Google Cloud Storage integration (storage, importer, exporter)";
    homepage = "https://github.com/PlakarKorp/integrations";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
