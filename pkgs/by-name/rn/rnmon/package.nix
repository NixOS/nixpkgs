{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rnmon";
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lbatalha";
    repo = "rnmon";
    tag = finalAttrs.version;
    hash = "sha256-aGveHnv8gmsSyWF25z8RV8mKvdcB4/dGUg2DHtfCRvs=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = with python3Packages; [
    pyyaml
    requests
    rns
  ];

  pythonImportsCheck = [
    "rnmon"
  ];

  # No tests in the repository
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "RNS Monitoring Agent";
    homepage = "https://github.com/lbatalha/rnmon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "rnmon";
  };
})
