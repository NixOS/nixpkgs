{
  lib,
  nix-update-script,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonApplication rec {
  pname = "hyperglot";
  version = "0.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/3zg/CsX0r5w7MyIkxCN40TYukmm9u0xJQJCeKrDHT0=";
  };

  dependencies = with python3Packages; [
    click
    fonttools
    uharfbuzz
    pyyaml
    colorlog
  ];

  build-system = [ python3Packages.setuptools ];

  pythonImportsCheck = [ "hyperglot" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Database and tools for detecting language support in fonts";
    homepage = "https://hyperglot.rosettatype.com";
    changelog = "https://github.com/rosettatype/hyperglot/blob/${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ imatpot ];
    mainProgram = "hyperglot";
  };
}
