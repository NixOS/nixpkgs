{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  requests,
}:
let
  inherit (netbox.plugins) netbox-proxbox;
in
buildPythonPackage (finalAttrs: {
  pname = "netbox-ceph";
  version = "0.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "emersonfelipesp";
    repo = "netbox-ceph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pBxvGgsi+/MX9RgXi+IiSlICQ/X8LO6gB1zg1ZYhcgY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    netbox-proxbox
    requests
  ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_ceph" ];

  passthru.pluginName = "netbox_ceph";

  meta = {
    description = "NetBox Plugin to support Proxmox Ceph";
    homepage = "https://github.com/emersonfelipesp/netbox-ceph";
    changelog = "https://github.com/emersonfelipesp/netbox-ceph/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
