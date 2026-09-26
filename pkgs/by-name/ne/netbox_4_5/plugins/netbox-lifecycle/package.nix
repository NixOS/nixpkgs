{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  pytestCheckHook,
  python,
  django-polymorphic,
}:

buildPythonPackage (finalAttrs: {
  pname = "netbox-lifecycle";
  version = "1.1.9";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DanSheps";
    repo = "netbox-lifecycle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iCBlwhaf6IFdni7FQyRPtRJVwt04w0Jc4R0CeQlIWCY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_lifecycle" ];

  dependencies = [ django-polymorphic ];

  meta = {
    description = "NetBox plugin for managing Hardware EOL/EOS, and Support Contracts";
    homepage = "https://github.com/DanSheps/netbox-lifecycle";
    changelog = "https://github.com/DanSheps/netbox-lifecycle/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
