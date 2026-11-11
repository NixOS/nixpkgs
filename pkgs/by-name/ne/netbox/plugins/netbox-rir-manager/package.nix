{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyregrws,
  tenacity,
  geopy,
  pycountry,
  netbox,
  python,
}:
buildPythonPackage (finalAttrs: {
  pname = "netbox-rir-manager";
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jsenecal";
    repo = "netbox-rir-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f92BI1ziFSpUbtfs3kw7iOhCcLE5iU9Dsv7L/+1nHrc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyregrws
    tenacity
    geopy
    pycountry
  ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_rir_manager" ];

  passthru.pluginName = "netbox_rir_manager";

  meta = {
    description = "NetBox plugin for managing RIR (ARIN, RIPE, etc.) resources";
    homepage = "https://github.com/jsenecal/netbox-rir-manager";
    changelog = "https://github.com/jsenecal/netbox-rir-manager/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
