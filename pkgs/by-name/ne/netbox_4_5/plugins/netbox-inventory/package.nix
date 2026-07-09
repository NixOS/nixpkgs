{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "netbox-inventory";
  version = "2.6.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ArnesSI";
    repo = "netbox-inventory";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gPCFEfMD5niCbI/++CvTTEHN+BtoZx7Yihher9yjWuU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_inventory" ];

  meta = {
    description = "NetBox plugin to manage hardware inventory";
    homepage = "https://github.com/ArnesSI/netbox-inventory";
    changelog = "https://github.com/ArnesSI/netbox-inventory/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
