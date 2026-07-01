{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  netbox,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "netbox-lists";
  version = "4.0.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "devon-mar";
    repo = "netbox-lists";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RRUuvoeB3xfqlZr1v1zpRdmVZK9av52ZsADOh9s4toQ=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;
  pythonImportsCheck = [ "netbox_lists" ];

  passthru.pluginName = "netbox_lists";

  meta = {
    description = "NetBox plugin to generate IP and prefix lists. Integrates with Ansible, Terraform, Prometheus, Oxidized and more";
    homepage = "https://github.com/devon-mar/netbox-lists";
    changelog = "https://github.com/devon-mar/netbox-lists/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
