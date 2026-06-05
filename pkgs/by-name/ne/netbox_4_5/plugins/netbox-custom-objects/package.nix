{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  python,
}:

buildPythonPackage rec {
  pname = "netbox-custom-objects";
  version = "0.5.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "netboxlabs";
    repo = "netbox-custom-objects";
    tag = "v${version}";
    hash = "sha256-8PEqt6TpoQ8ncyZPesRos0BQHF3cKIzgoFr56v8UTTY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_custom_objects" ];

  meta = {
    description = "NetBox plugin to create new object types";
    homepage = "https://github.com/netboxlabs/netbox-custom-objects";
    changelog = "https://github.com/netboxlabs/netbox-custom-objects/releases/tag/${src.tag}";
    license = lib.licenses.netboxLimitedUse;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
