{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sqids,
  netbox,
  python,
}:
buildPythonPackage (finalAttrs: {
  pname = "netbox-sqids";
  version = "0.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jsenecal";
    repo = "netbox-sqids";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c25xnN6aC1GUtVGOdE0uXMM79L/MMO2Cd3avr6eWwXA=";
  };

  build-system = [ setuptools ];

  dependencies = [ sqids ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_sqids" ];

  passthru.pluginName = "netbox_sqids";

  meta = {
    description = "NetBox plugin for short, URL-safe, globally unique identifiers";
    homepage = "https://github.com/jsenecal/netbox-sqids";
    changelog = "https://github.com/jsenecal/netbox-sqids/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
