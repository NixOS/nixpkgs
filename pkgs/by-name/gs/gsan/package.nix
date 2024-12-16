{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gsan";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "franccesco";
    repo = "getaltname";
    rev = "refs/tags/v${version}";
    hash = "sha256-Os/NappuvdadGqCouF5vhvPhRnu1SLpii+Esq0C1j48=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    cryptography
    pyasn1
    pyopenssl
    rich
    typer
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "gsan" ];

  meta = {
    description = "Tool to extract subdomains from SSL certificates in HTTPS sites";
    homepage = "https://github.com/franccesco/getaltname";
    changelog = "https://github.com/franccesco/getaltname/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gsan";
  };
}
