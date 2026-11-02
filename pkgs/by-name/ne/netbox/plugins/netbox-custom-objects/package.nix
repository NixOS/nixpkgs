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
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netboxlabs";
    repo = "netbox-custom-objects";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VY31ITIqVpuW3jPOhozTKUL6ka2CE80w+guaksjg8zw=";
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
