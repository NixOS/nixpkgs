{
  lib,
  buildPythonPackage,
  fetchPypi,
  ntc-templates,
  paramiko,
  poetry-core,
  pyserial,
  pythonOlder,
  pyyaml,
  scp,
  setuptools,
  textfsm,
}:

buildPythonPackage rec {
  pname = "netmiko";
  version = "4.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Jf8SN5dqo/8srPBJSTFGOMiZIgoWdb0CnjGwfOIM47Y=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry>=1.6.1" "poetry-core" \
      --replace-fail "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    ntc-templates
    paramiko
    pyserial
    pyyaml
    scp
    setuptools
    textfsm
  ];

  # Tests require closed-source pyats and genie packages
  doCheck = false;

  pythonImportsCheck = [ "netmiko" ];

  meta = with lib; {
    description = "Multi-vendor library to simplify Paramiko SSH connections to network devices";
    homepage = "https://github.com/ktbyers/netmiko/";
    changelog = "https://github.com/ktbyers/netmiko/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.astro ];
  };
}
