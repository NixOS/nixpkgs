{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ldeep";
  version = "1.0.88";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "franc-pentest";
    repo = "ldeep";
    tag = version;
    hash = "sha256-Auh9KCyPO1bWKY1wd9As5eycJfUhj0IhX/9xp99skhA=";
  };

  pythonRelaxDeps = [
    "termcolor"
    "cryptography"
    "ldap3-bleeding-edge"
  ];

  build-system = with python3.pkgs; [ pdm-backend ];

  nativeBuildInputs = with python3.pkgs; [ cython ];

  dependencies = with python3.pkgs; [
    commandparse
    cryptography
    dnspython
    gssapi
    ldap3-bleeding-edge
    oscrypto
    pycryptodome
    pycryptodomex
    six
    termcolor
    tqdm
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ldeep" ];

  meta = with lib; {
    description = "In-depth LDAP enumeration utility";
    homepage = "https://github.com/franc-pentest/ldeep";
    changelog = "https://github.com/franc-pentest/ldeep/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "ldeep";
  };
}
