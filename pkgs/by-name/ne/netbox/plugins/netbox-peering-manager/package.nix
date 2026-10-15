{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx,
  tenacity,
  netbox,
  python,
}:
let
  inherit (netbox.plugins) netbox-routing;
in
buildPythonPackage (finalAttrs: {
  pname = "netbox-peering-manager";
  version = "0.3.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jsenecal";
    repo = "netbox-peering-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+sgQo2ahFHNNfSK8MTT75BbFTgf4GqFRxF9DZtBu2yI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    netbox-routing
    tenacity
    httpx
  ];

  pythonRelaxDeps = [ "netbox-routing" ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_peering_manager" ];

  passthru.pluginName = "netbox_peering_manager";

  meta = {
    description = "NetBox plugin for BGP Peering and related objects documentation";
    homepage = "https://jsenecal.github.io/netbox-peering-manager/";
    changelog = "https://github.com/jsenecal/netbox-peering-manager/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
