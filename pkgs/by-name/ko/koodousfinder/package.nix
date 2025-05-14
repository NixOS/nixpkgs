{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "koodousfinder";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "teixeira0xfffff";
    repo = "KoodousFinder";
    # Not properly tagged, https://github.com/teixeira0xfffff/KoodousFinder/issues/7
    #rev = "refs/tags/v${version}";
    rev = "d9dab5572f44e5cd45c04e6fcda38956897855d1";
    hash = "sha256-skCbt2lDKgSyZdHY3WImbr6CF0icrDPTIXNV1736gKk=";
  };

  pythonRelaxDeps = [ "keyring" ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    keyring
    requests
  ];

  # Project has no tests, re-check with next release
  doCheck = false;

  pythonImportsCheck = [ "koodousfinder" ];

  meta = with lib; {
    description = "Tool to allows users to search for and analyze Android apps";
    homepage = "https://github.com/teixeira0xfffff/KoodousFinder";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
