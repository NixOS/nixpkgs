{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  python,
}:
buildPythonPackage (finalAttrs: {
  pname = "netbox-cable-labels";
  version = "0.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jsenecal";
    repo = "netbox-cable-labels";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aTZXCHRyumfYk50bc0rFiDGscZt1n+fsW2uYZAkZwOQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_cable_labels" ];

  passthru.pluginName = "netbox_cable_labels";

  meta = {
    description = "NetBox plugin for automated label generated based on a user defined template";
    homepage = "https://github.com/jsenecal/netbox-cable-labels";
    changelog = "https://github.com/jsenecal/netbox-cable-labels/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
