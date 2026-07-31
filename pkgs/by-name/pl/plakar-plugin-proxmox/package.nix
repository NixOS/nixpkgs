{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "plakar-plugin-proxmox";
  version = "1.1.0-rc.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PlakarKorp";
    repo = "integrations";
    tag = "proxmox/v${finalAttrs.version}";
    hash = "sha256-Pl84JZlpV1agMzvnX1eIZxSiTHQDKUpzAVlXlN/rygQ=";
  };

  vendorHash = "sha256-6jARmuJlCHTKuqMhZGX7CXPG+K3Cht8P4jztAkU2fY4=";

  sourceRoot = "${finalAttrs.src.name}/proxmox";

  subPackages = [
    "plugin/importer"
    "plugin/exporter"
  ];

  postInstall = ''
    dest="$out/share/plakar/plugins/v1.1.0/proxmox_v${finalAttrs.version}_$(go env GOOS)_$(go env GOARCH)"
    mkdir -p "$dest"
    install -m0644 manifest.yaml "$dest/manifest.yaml"
    mv "$out/bin/importer" "$dest/proxmoxImporter"
    mv "$out/bin/exporter" "$dest/proxmoxExporter"
    rmdir "$out/bin" 2>/dev/null || true
  '';

  meta = {
    description = "Plakar Proxmox VE integration (vzdump backup and restore of VMs and containers)";
    homepage = "https://github.com/PlakarKorp/integrations";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
