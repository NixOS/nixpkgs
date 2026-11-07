{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  djangorestframework-gis,
  networkx,
  netbox,
  python,
}:
buildPythonPackage (finalAttrs: {
  pname = "netbox-pathways";
  version = "0.2.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jsenecal";
    repo = "netbox-pathways";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+XcoElTbAeCaHJfySwO1P84p+mtssZsW2bg5lwMfVD4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    djangorestframework-gis
    networkx
  ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_pathways" ];

  passthru.pluginName = "netbox_pathways";

  meta = {
    description = "NetBox plugin for Fiber Management System: fiber cable management, splice planning, and circuit provisioning";
    homepage = "https://jsenecal.github.io/netbox-pathways/";
    changelog = "https://jsenecal.github.io/netbox-pathways/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
