{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  gssapi,
  impacket,
  ldap3-bleeding-edge,
  lxml,
  pyasn1,
  pycryptodome,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pywerview";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "the-useless-one";
    repo = "pywerview";
    rev = "refs/tags/v${version}";
    hash = "sha256-Mi06l6D3DSkz27resq9KingaXHK+lKn3W5VBLQahLO8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    gssapi
    impacket
    ldap3-bleeding-edge
    lxml
    pycryptodome
    pyasn1
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pywerview" ];

  meta = with lib; {
    description = "Module for PowerSploit's PowerView support";
    homepage = "https://github.com/the-useless-one/pywerview";
    changelog = "https://github.com/the-useless-one/pywerview/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pywerview";
  };
}
