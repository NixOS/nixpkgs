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
  pname = "netbox-secrets";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Onemind-Services-LLC";
    repo = "netbox-secrets";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1z1MtA9ej+xlASvIzs9mXmwxLhHSO/35nWjn8x/MkMk=";
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
