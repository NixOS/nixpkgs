{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pandantic,
  websockets,
  netbox,
}:
buildPythonPackage (finalAttrs: {
  pname = "netbox-proxbox";
  version = "0.0.18";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "emersonfelipesp";
    repo = "netbox-proxbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZICFFEcVAnBeZyg82691duHvtQaUnB//LdTd9U0wgcw=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pandantic
    websockets
  ];

  pythonRelaxDeps = [ "pydantic" ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_proxbox" ];

  meta = {
    description = "Netbox Plugin for integration between Proxmox and Netbox";
    homepage = "https://emersonfelipesp.com/netbox-proxbox";
    changelog = "https://github.com/emersonfelipesp/netbox-proxbox/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
