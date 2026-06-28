{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "netbox-data-flows";
  version = "1.5.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Alef-Burzmali";
    repo = "netbox-data-flows";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fry8AK0qgPs+QC5L2oilGSY68m1Y9KHWQ/QOzQ7B2+k=";
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
