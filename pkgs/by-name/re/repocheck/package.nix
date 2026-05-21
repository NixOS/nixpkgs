{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "repocheck";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kynikos";
    repo = "repocheck";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pCz+oAfDFyDeuXumfNzLTXnftM9+IG+lZzWSKtbZ9dg=";
  };

  build-system = [ python3Packages.setuptools ];

  pythonImportsCheck = [ "repocheck" ];

  # no tests
  doCheck = false;

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Check the status of code repositories under a root directory";
    mainProgram = "repocheck";
    license = lib.licenses.gpl3Plus;
  };
})
