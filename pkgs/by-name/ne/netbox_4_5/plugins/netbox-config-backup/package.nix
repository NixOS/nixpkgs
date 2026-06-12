{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  pytestCheckHook,
  python,
  netbox-napalm-plugin,
  pydriller,
}:

buildPythonPackage (finalAttrs: {
  pname = "netbox-config-backup";
  version = "2.2.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DanSheps";
    repo = "netbox-config-backup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PT7/RCpB7SAinQ8McQV59b9ouqqUSoEqEj0ultL37cs=";
  };

  build-system = [ setuptools ];

  pythonRemoveDeps = [ "uuid" ]; # python builtin

  dependencies = [
    netbox-napalm-plugin
    pydriller
  ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_config_backup" ];

  passthru.pluginName = "netbox_config_backup";

  meta = {
    description = "NetBox plugin for configuration backups using napalm";
    homepage = "https://github.com/DanSheps/netbox-config-backup";
    changelog = "https://github.com/DanSheps/netbox-config-backup/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
