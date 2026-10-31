{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  icalendar,
  netbox,
  python,
}:
buildPythonPackage (finalAttrs: {
  pname = "netbox-notices";
  version = "1.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jsenecal";
    repo = "netbox-notices";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o7qVBtqrYXm6PsgO2evYjHgjrMMBDd+DCyzXT8pTXNU=";
  };

  build-system = [ setuptools ];

  dependencies = [ icalendar ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "notices" ];

  passthru.pluginName = "notices";

  meta = {
    description = "NetBox plugin to track maintenance and outage events against NetBox models";
    homepage = "https://github.com/jsenecal/netbox-notices";
    changelog = "https://github.com/jsenecal/netbox-notices/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
