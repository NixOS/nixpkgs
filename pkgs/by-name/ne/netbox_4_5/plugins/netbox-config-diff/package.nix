{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  python,
  hier-config,
  netutils,
  scrapli,
  scrapli-cfg,
  scrapli-community,
}:

buildPythonPackage (finalAttrs: {
  pname = "netbox-config-diff";
  version = "2.14.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "miaow2";
    repo = "netbox-config-diff";
    tag = finalAttrs.version;
    hash = "sha256-OREnrxfEJoAXpklYPkNYHruFWgK0WflpWQxoO7MIf2g=";
  };

  build-system = [ setuptools ];

  pythonRemoveDeps = [ "scrapli" ];

  pythonRelaxDeps = [
    "hier-config"
    "netutils"
  ];

  dependencies = [
    hier-config
    netutils
    scrapli
    scrapli-cfg
    scrapli-community
  ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_config_diff" ];

  passthru.pluginName = "netbox_config_diff";

  meta = {
    description = "NetBox plugin to find diff, push rendered device configurations to devices and apply them";
    homepage = "https://miaow2.github.io/netbox-config-diff/";
    changelog = "https://github.com/miaow2/netbox-config-diff/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
