{
  lib,
  python3,
  fetchPypi,
  nix-update-script,
  versionCheckHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "snakefmt";
  version = "0.11.3";
  pyproject = true;

  disabled = python3.pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PvuC9mwFl3EhJq1UDsFc7iTXl+RDiU/YbM9qqQdQbsA=";
  };

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    black
    click
  ];

  pythonRelaxDeps = [
    "black"
    "click"
  ];

  pythonImportsCheck = [ "snakefmt" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Uncompromising Snakemake code formatter";
    homepage = "https://pypi.org/project/snakefmt/";
    changelog = "https://github.com/snakemake/snakefmt/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jolars ];
    mainProgram = "snakefmt";
  };
}
