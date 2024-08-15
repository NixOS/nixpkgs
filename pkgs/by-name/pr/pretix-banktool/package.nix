{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch2,
}:

python3Packages.buildPythonApplication rec {
  pname = "pretix-banktool";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-banktool";
    rev = "v${version}";
    hash = "sha256-vYHjotx1RujPV53Ei7bXAc3kL/3cwbWQB1T3sQ15MFA=";
  };

  patches = [
    (fetchpatch2 {
      # migrate to pyproject.toml, relax constraints
      url = "https://github.com/pretix/pretix-banktool/commit/48a8125aba86d70f62c2b1f88bcf21c783402589.patch";
      hash = "sha256-HbVzWoI5LlNyh0MZnPsLmzu7RMY8/BDfOwgDWMD+k5w=";
    })
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    click
    fints
    requests
    mt-940
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "pretix_banktool" ];

  meta = with lib; {
    description = "Automatic bank data upload tool for pretix (with FinTS client)";
    homepage = "https://github.com/pretix/pretix-banktool";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "pretix-banktool";
  };
}
