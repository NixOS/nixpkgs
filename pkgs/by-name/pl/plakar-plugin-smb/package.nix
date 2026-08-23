{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "plakar-plugin-smb";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "integrations";
    tag = "smb/v${finalAttrs.version}";
    hash = "sha256-hXrf9GWIiKa5k94bnU5bld45gITeZETchO5NiCQVpy0=";
  };

  vendorHash = "sha256-eSRPuw1lsRl1fow1Ml5WyRMmKI5sGBt4C1S6JSNNHrg=";

  sourceRoot = "${finalAttrs.src.name}/smb";

  subPackages = [
    "plugin/importer"
    "plugin/exporter"
  ];

  postInstall = ''
    dest="$out/share/plakar/plugins/v1.1.0/smb_v${finalAttrs.version}_$(go env GOOS)_$(go env GOARCH)"
    mkdir -p "$dest"
    install -m0644 manifest.yaml "$dest/manifest.yaml"
    mv "$out/bin/importer" "$dest/smbImporter"
    mv "$out/bin/exporter" "$dest/smbExporter"
    rmdir "$out/bin" 2>/dev/null || true
  '';

  meta = {
    description = "Plakar SMB integration (importer, exporter)";
    homepage = "https://github.com/PlakarKorp/integrations";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
