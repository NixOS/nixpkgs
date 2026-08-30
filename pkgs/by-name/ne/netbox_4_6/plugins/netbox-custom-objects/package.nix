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

  pname = "netbox-custom-objects";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netboxlabs";
    repo = "netbox-custom-objects";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3ftZQWymD23+k29t6s6IE12JMvfGBcqaGZaFyaEWwrE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;
  dontCheckPythonMetadata = true;
  pythonImportsCheck = [ "netbox_custom_objects" ];
  passthru.pluginName = "netbox_custom_objects";

  meta = {
    description = "NetBox plugin to create new object types";
    homepage = "https://github.com/netboxlabs/netbox-custom-objects";
    changelog = "https://github.com/netboxlabs/netbox-custom-objects/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.netboxLimitedUse;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
