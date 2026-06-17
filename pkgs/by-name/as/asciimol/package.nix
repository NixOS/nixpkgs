{
  fetchPypi,
  lib,
  nix-update-script,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "asciimol";
  version = "1.2.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-sB8hHtjfCv5jFHXEoUG7zNn3d3QKihPLbgnR+Jyz4GQ=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    numpy
    ase
    rdkit
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Curses based ASCII molecule viewer for terminals";
    license = lib.licenses.bsd2;
    homepage = "https://github.com/dewberryants/asciimol";
    downloadPage = "https://pypi.org/project/asciimol/";
    maintainers = with lib.maintainers; [ tomasrivera ];
    mainProgram = "asciimol";
  };
})
