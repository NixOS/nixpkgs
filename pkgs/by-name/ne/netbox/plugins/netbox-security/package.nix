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

  pname = "netbox-security";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andy-shady-org";
    repo = "netbox-security";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0vTMmQjTNSFnEVbVMkI0EOzGY2B0NR0NLbIHheppb6k=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;
  pythonImportsCheck = [ "netbox_security" ];

  passthru.pluginName = "netbox_security";

  meta = {
    description = "NetBox plugin covering various security and NAT related models";
    homepage = "https://github.com/andy-shady-org/netbox-security";
    changelog = "https://github.com/andy-shady-org/netbox-security/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
