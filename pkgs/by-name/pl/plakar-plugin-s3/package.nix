{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "plakar-plugin-s3";
  version = "1.1.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "integrations";
    tag = "s3/v${finalAttrs.version}";
    hash = "sha256-kspJe3s+ucuFf4ylrQw7+ws2xZRN26/9fjPjSlyHVBc=";
  };

  vendorHash = "sha256-1QahkpFeVye8+jjkjE3YE4RDfeM9pvDth90kmm079Ik=";

  sourceRoot = "${finalAttrs.src.name}/s3";

  subPackages = [
    "plugin/importer"
    "plugin/exporter"
    "plugin/storage"
  ];

  postInstall = ''
    dest="$out/share/plakar/plugins/v1.1.0/s3_v${finalAttrs.version}_$(go env GOOS)_$(go env GOARCH)"
    mkdir -p "$dest"
    install -m0644 manifest.yaml "$dest/manifest.yaml"
    mv "$out/bin/importer" "$dest/s3Importer"
    mv "$out/bin/exporter" "$dest/s3Exporter"
    mv "$out/bin/storage" "$dest/s3Storage"
    rmdir "$out/bin" 2>/dev/null || true
  '';

  meta = {
    description = "Plakar S3 integration (storage, importer, exporter)";
    homepage = "https://github.com/PlakarKorp/integrations";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
