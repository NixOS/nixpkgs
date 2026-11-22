{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  django,
  netaddr,
  python,
}:
buildPythonPackage (finalAttrs: {
  pname = "netbox-topology-views";
  version = "5.0.0";
  pyproject = true;

  disabled = python.pythonVersion != netbox.python.pythonVersion;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-topology-views";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gu8VZ1QmphhwW4nRyTSfnJ3vMGcnfC1pPeQrVCFMASE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    netbox
    django
    netaddr
  ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;
  pythonImportsCheck = [ "netbox_topology_views" ];

  passthru.pluginName = "netbox_topology_views";

  meta = {
    description = "Netbox plugin for generate topology views/maps from your devices";
    homepage = "https://github.com/netbox-community/netbox-topology-views";
    changelog = "https://github.com/netbox-community/netbox-topology-views/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
