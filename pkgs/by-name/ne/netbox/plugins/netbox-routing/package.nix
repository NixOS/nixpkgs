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
  pname = "netbox-routing";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DanSheps";
    repo = "netbox-routing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e4CSO1Tl4J7Nwmqp4Pi+x7h61elgtzBOco/GclT1VtU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;
  pythonImportsCheck = [ "netbox_routing" ];

  dependencies = [ django-polymorphic ];

  passthru.pluginName = "netbox_routing";

  meta = {
    description = "NetBox plugin for tracking all kinds of routing information";
    homepage = "https://github.com/DanSheps/netbox-routing";
    changelog = "https://github.com/DanSheps/netbox-routing/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benley ];
  };
})
