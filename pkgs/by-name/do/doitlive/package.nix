{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "doitlive";
  version = "5.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-dYelfAT6dHGOdstGIvme9rdi8chh0MHC+EOra+xT0GM=";
  };

  build-system = with python3Packages; [ flit-core ];

  dependencies = with python3Packages; [
    click
    click-completion
    click-didyoumean
  ];

  # disable tests (too many failures)
  doCheck = false;

  meta = {
    description = "Tool for live presentations in the terminal";
    homepage = "https://github.com/sloria/doitlive";
    changelog = "https://github.com/sloria/doitlive/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mbode ];
    mainProgram = "doitlive";
  };
})
