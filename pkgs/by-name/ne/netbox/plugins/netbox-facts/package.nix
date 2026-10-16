{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  napalm,
  netbox,
  python,
}:
buildPythonPackage (finalAttrs: {
  pname = "netbox-facts";
  version = "0.1.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jsenecal";
    repo = "netbox-facts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ljLQgAsyIYWTLrJRLg1AYOjThXnGUy52Maq8vcncdS8=";
  };

  build-system = [ hatchling ];

  dependencies = [ napalm ];

  pythonRelaxDeps = [ "requests" ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_facts" ];

  passthru.pluginName = "netbox_facts";

  meta = {
    description = "NetBox plugin to gather operational facts about devices";
    homepage = "https://github.com/jsenecal/netbox-facts";
    changelog = "https://github.com/jsenecal/netbox-facts/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
})
