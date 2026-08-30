{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  python,
  napalm,
  django,
}:
buildPythonPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "netbox-napalm-plugin";
  version = "0.3.5";
  pyproject = true;

  disabled = python.pythonVersion != netbox.python.pythonVersion;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-napalm-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dtoiA6gvWL6aGBHmHTwqK8L0qRyA83GcUCGAmg9Xo8w=";
  };

  build-system = [ setuptools ];

  dependencies = [ napalm ];

  nativeCheckInputs = [
    netbox
    django
  ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_napalm_plugin" ];

  passthru.pluginName = "netbox_napalm_plugin";

  meta = {
    description = "Netbox plugin for Napalm integration";
    homepage = "https://github.com/netbox-community/netbox-napalm-plugin";
    changelog = "https://github.com/netbox-community/netbox-napalm-plugin/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
