{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  python,
  django-polymorphic,
}:
buildPythonPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "netbox-lifecycle";
  version = "1.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DanSheps";
    repo = "netbox-lifecycle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XJRToa07iMVMg6AmA0v9OHsF75ZtS74OByKIKLzErBM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;
  pythonImportsCheck = [ "netbox_lifecycle" ];

  dependencies = [ django-polymorphic ];

  passthru.pluginName = "netbox_lifecycle";

  meta = {
    description = "NetBox plugin for managing Hardware EOL/EOS, and Support Contracts";
    homepage = "https://github.com/DanSheps/netbox-lifecycle";
    changelog = "https://github.com/DanSheps/netbox-lifecycle/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
