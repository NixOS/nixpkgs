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
  pname = "netbox-security";
  version = "1.5.10";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "andy-shady-org";
    repo = "netbox-security";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DOutzFIF/ey2o9M3sb15rmbGJyzsTXfiwC5Rqks8vxc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_security" ];

  meta = {
    description = "NetBox plugin covering various security and NAT related models";
    homepage = "https://github.com/andy-shady-org/netbox-security";
    changelog = "https://github.com/andy-shady-org/netbox-security/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
