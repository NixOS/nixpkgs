{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  python,
}:
buildPythonPackage (finalAttrs: {
  pname = "netbox-fms";
  version = "0.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jsenecal";
    repo = "netbox-fms";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5RPcJFxwQYJWUipHU05gp7zovWPnviWHlkqCHEs16tw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_fms" ];

  passthru.pluginName = "netbox_fms";

  meta = {
    description = "NetBox plugin for Fiber Management System: fiber cable management, splice planning, and circuit provisioning";
    homepage = "https://jsenecal.github.io/netbox-fms/";
    changelog = "https://jsenecal.github.io/netbox-fms/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
