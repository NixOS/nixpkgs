{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dnstwist";
  version = "20240812";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elceef";
    repo = "dnstwist";
    rev = "refs/tags/${version}";
    hash = "sha256-J6MfPKj7iACsiiSUU/2gxQdwtmqw9NKnjDoSdhxKoAw=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    dnspython
    geoip
    ppdeep
    requests
    tld
    whois
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "dnstwist"
  ];

  meta = with lib; {
    description = "Domain name permutation engine for detecting homograph phishing attacks";
    homepage = "https://github.com/elceef/dnstwist";
    changelog = "https://github.com/elceef/dnstwist/releases/tag/${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "dnstwist";
  };
}
