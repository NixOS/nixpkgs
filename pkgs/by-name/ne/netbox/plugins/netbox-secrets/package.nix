{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  python,
  pycryptodome,
}:

buildPythonPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "netbox-secrets";
  version = "3.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Onemind-Services-LLC";
    repo = "netbox-secrets";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XB4upeu2C2ok0jmLX47tOjrjV4b/WXCpgtlRz9+MgAs=";
  };

  build-system = [ setuptools ];

  dependencies = [ pycryptodome ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;
  pythonImportsCheck = [ "netbox_secrets" ];

  passthru.pluginName = "netbox_secrets";

  meta = {
    description = "NetBox plugin to enhance secret management with encrypted storage and flexible, user-friendly features";
    homepage = "https://github.com/Onemind-Services-LLC/netbox-secrets";
    changelog = "https://github.com/Onemind-Services-LLC/netbox-secrets/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
