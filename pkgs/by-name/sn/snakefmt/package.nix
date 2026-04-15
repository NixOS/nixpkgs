{
  lib,
  python3,
  fetchPypi,
  nix-update-script,
  versionCheckHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "snakefmt";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-S6evESaS1IJ3YFn3jjhccNhzkBTFOL9Xt37DuLcDKeI=";
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
    changelog = "https://github.com/snakemake/snakefmt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jolars ];
    mainProgram = "snakefmt";
  };
})
