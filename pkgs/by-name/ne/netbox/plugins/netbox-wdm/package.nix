{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  python,
}:
buildPythonPackage (finalAttrs: {
  pname = "netbox-wdm";
  version = "0.2.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jsenecal";
    repo = "netbox-wdm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wSW9nLqUIt+L4f8wlqX+Ox7rLnlqzRfQKpf44k+PhKE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_wdm" ];

  passthru.pluginName = "netbox_wdm";

  meta = {
    description = "NetBox plugin for WDM wavelength management, ITU channel plans, ROADM editing, and wavelength service tracking";
    homepage = "https://jsenecal.github.io/netbox-wdm/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
