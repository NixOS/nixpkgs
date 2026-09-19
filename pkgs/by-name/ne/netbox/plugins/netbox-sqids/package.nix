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
  version = "0.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jsenecal";
    repo = "netbox-sqids";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B9BUjaKUqORlITbjiDYFetCaSx8lL0ECRU9yuPkoA0k=";
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
