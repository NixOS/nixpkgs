{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  python,
}:
buildPythonPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "netbox-reorder-rack";
  version = "1.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-reorder-rack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DRbWLXQU3W4t0kiUUt0qHLHvuz2sLiH4astl8N8zO38=";
  };

  build-system = [
    setuptools
  ];

  checkInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;
  pythonImportsCheck = [ "netbox_reorder_rack" ];

  passthru.pluginName = "netbox_reorder_rack";

  meta = {
    description = "NetBox plugin to allow users to reorder devices within a rack using a drag and drop UI";
    homepage = "https://github.com/netbox-community/netbox-reorder-rack";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ minijackson ];
  };
})
