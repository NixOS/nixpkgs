{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "ldeep";
  version = "1.0.89";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "franc-pentest";
    repo = "ldeep";
    tag = finalAttrs.version;
    hash = "sha256-aod+0wd4Ek8mTiP4H5C5vUJ+94THMrFGDGVzWEH3G+U=";
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

  meta = {
    description = "In-depth LDAP enumeration utility";
    homepage = "https://github.com/franc-pentest/ldeep";
    changelog = "https://github.com/franc-pentest/ldeep/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ldeep";
  };
})
