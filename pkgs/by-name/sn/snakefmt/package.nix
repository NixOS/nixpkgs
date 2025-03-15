{
  lib,
  python3,
  fetchPypi,
  nix-update-script,
  versionCheckHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "snakefmt";
  version = "0.10.2";
  pyproject = true;

  disabled = python3.pythonOlder "3.8.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QoalkDtm2n5SdjxegYTaTtyVETt1j0RIUogE+1T5t1o=";
  };

  build-system = [ python3.pkgs.poetry-core ];

  dependencies = with python3.pkgs; [
    black
    click
    importlib-metadata
    toml
  ];

  pythonImportsCheck = [ "snakefmt" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
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
