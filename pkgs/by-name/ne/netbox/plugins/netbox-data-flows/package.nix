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

  pname = "netbox-data-flows";
  version = "1.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Alef-Burzmali";
    repo = "netbox-data-flows";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RJrS0B5MZBshSWl4ZL53kz1nK6UvUYmL8JSA4NEAzRo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;
  pythonImportsCheck = [ "netbox_data_flows" ];

  passthru.pluginName = "netbox_data_flows";

  meta = {
    description = "NetBox plugin to document data flows between systems and applications";
    homepage = "https://github.com/Alef-Burzmali/netbox-data-flows";
    changelog = "https://github.com/Alef-Burzmali/netbox-data-flows/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
