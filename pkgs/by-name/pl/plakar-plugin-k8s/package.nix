{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "plakar-plugin-k8s";
  version = "1.1.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "integrations";
    tag = "k8s/v${finalAttrs.version}";
    hash = "sha256-eGNLeKhb/jc8RvYlwPkOVDlN8tCO9Rmv8AACDYPK3D8=";
  };

  vendorHash = "sha256-HXuIiO5rxqA5vNOvFD+wlP08uACnDhwBO9Au62i65sE=";

  sourceRoot = "${finalAttrs.src.name}/k8s";

  subPackages = [
    "plugin/importer"
    "plugin/exporter"
    "plugin/inventory"
  ];

  postInstall = ''
    dest="$out/share/plakar/plugins/v1.1.0/k8s_v${finalAttrs.version}_$(go env GOOS)_$(go env GOARCH)"
    mkdir -p "$dest"
    install -m0644 manifest.yaml "$dest/manifest.yaml"
    mv "$out/bin/importer" "$dest/k8s-importer"
    mv "$out/bin/exporter" "$dest/k8s-exporter"
    mv "$out/bin/inventory" "$dest/k8s-inventory"
    rmdir "$out/bin" 2>/dev/null || true
  '';

  meta = {
    description = "Plakar Kubernetes integration (importer, exporter, inventory)";
    homepage = "https://github.com/PlakarKorp/integrations";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
