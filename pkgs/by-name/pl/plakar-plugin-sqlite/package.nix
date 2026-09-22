{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "plakar-plugin-sqlite";
  version = "1.0.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "integrations";
    tag = "sqlite/v${finalAttrs.version}";
    hash = "sha256-NDz3FDeg5CVONYdfNM5Kfv+A2I/axjxJfilAMSDtDVg=";
  };

  vendorHash = "sha256-WUgVdxlP/RTJTDl2htIvotPCF+uHs3rDKtlwxO6mDaI=";

  sourceRoot = "${finalAttrs.src.name}/sqlite";

  subPackages = [
    "plugin/storage"
  ];

  postInstall = ''
    dest="$out/share/plakar/plugins/v1.1.0/sqlite_v${finalAttrs.version}_$(go env GOOS)_$(go env GOARCH)"
    mkdir -p "$dest"
    install -m0644 manifest.yaml "$dest/manifest.yaml"
    mv "$out/bin/storage" "$dest/sqliteStorage"
    rmdir "$out/bin" 2>/dev/null || true
  '';

  meta = {
    description = "Plakar SQLite integration (storage)";
    homepage = "https://github.com/PlakarKorp/integrations";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
