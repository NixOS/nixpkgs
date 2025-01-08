{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "repocheck";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kynikos";
    repo = "repocheck";
    tag = "v${version}";
    hash = "sha256-pCz+oAfDFyDeuXumfNzLTXnftM9+IG+lZzWSKtbZ9dg=";
  };

  build-system = [ python3Packages.setuptools ];

  pythonImportsCheck = [ "repocheck" ];

  # no tests
  doCheck = false;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Check the status of code repositories under a root directory";
    mainProgram = "repocheck";
    license = licenses.gpl3Plus;
  };
}
