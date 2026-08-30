{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox-routing,
  httpx,
  tenacity,
  netbox,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "netbox-peering-manager";
  version = "0.2.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jsenecal";
    repo = "netbox-peering-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lhSKwhguH3Uq0VtYicQhq/h62czz5DkwGTC7tdRvZWA=";
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

  meta = {
    description = "NetBox plugin for BGP Peering and related objects documentation";
    homepage = "https://jsenecal.github.io/netbox-peering-manager/";
    changelog = "https://github.com/jsenecal/netbox-peering-manager/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
