{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "plakar-plugin-nfs";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "integrations";
    tag = "nfs/v${finalAttrs.version}";
    hash = "sha256-skCtgOjoOot34E50FOBSSWyDzXV2Sm0YqyFCUmCJjb4=";
  };

  vendorHash = "sha256-ge35t2V0DaYlpv9BQ5uK+YSjmbbBI+l+ipQxNZrYyeM=";

  sourceRoot = "${finalAttrs.src.name}/nfs";

  subPackages = [
    "plugin/importer"
    "plugin/exporter"
  ];

  postInstall = ''
    dest="$out/share/plakar/plugins/v1.1.0/nfs_v${finalAttrs.version}_$(go env GOOS)_$(go env GOARCH)"
    mkdir -p "$dest"
    install -m0644 manifest.yaml "$dest/manifest.yaml"
    mv "$out/bin/importer" "$dest/nfsImporter"
    mv "$out/bin/exporter" "$dest/nfsExporter"
    rmdir "$out/bin" 2>/dev/null || true
  '';

  meta = {
    description = "Plakar NFS integration (importer, exporter)";
    homepage = "https://github.com/PlakarKorp/integrations";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
