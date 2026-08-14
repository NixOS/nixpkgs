{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rnmon";
  version = "0.3.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lbatalha";
    repo = "rnmon";
    tag = finalAttrs.version;
    hash = "sha256-3ou2F8ePKzh6g63X0l9iX1fTSVe9misGBkPlCUEWpiU=";
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
