{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  python,

  boto3,
  deepdiff,
  dimi,
  django-bootstrap5,
  dulwich,
  jq,
  netmiko,
  pydantic,
  scrapli-netconf,
  simpleeval,
  textfsm,
  ttp,
  xmltodict,
}:

buildPythonPackage (finalAttrs: {
  pname = "netbox-validity";
  version = "3.5.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "amyasnikov";
    repo = "validity";
    tag = finalAttrs.version;
    hash = "sha256-LKuyzO1CXAHCspT4AhHkK0NH3RelL/kGBXFOdaKHlOU=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "django-bootstrap5"
    "simpleeval"
    "textfsm"
    "xmltodict"
  ];

  dependencies = [
    boto3
    deepdiff
    dimi
    django-bootstrap5
    dulwich
    jq
    netmiko
    pydantic
    simpleeval
    scrapli-netconf
    textfsm
    ttp
    xmltodict
  ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "validity" ];

  passthru.pluginName = "validity";

  meta = {
    description = "NetBox plugin to validate network devices";
    homepage = "https://github.com/amyasnikov/validity";
    changelog = "https://github.com/amyasnikov/validity/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
