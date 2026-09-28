{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "plakar-plugin-etcd";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "integrations";
    tag = "etcd/v${finalAttrs.version}";
    hash = "sha256-8yFfZgHmMrYSUgj9BP6YyYGh76VOcNOcLNlU1aoOsgA=";
  };

  vendorHash = "sha256-Aujoj2xbPBIgeKQrmu0snVMr8MoWpuD2jEBQcuR60Q4=";

  sourceRoot = "${finalAttrs.src.name}/etcd";

  subPackages = [
    "cmd/importer"
  ];

  postInstall = ''
    dest="$out/share/plakar/plugins/v1.1.0/etcd_v${finalAttrs.version}_$(go env GOOS)_$(go env GOARCH)"
    mkdir -p "$dest"
    install -m0644 manifest.yaml "$dest/manifest.yaml"
    mv "$out/bin/importer" "$dest/etcd-importer"
    rmdir "$out/bin" 2>/dev/null || true
  '';

  meta = {
    description = "Plakar etcd integration (importer)";
    homepage = "https://github.com/PlakarKorp/integrations";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
