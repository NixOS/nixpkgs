{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "mathics-scanner";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mathics3";
    repo = "Mathics3-scanner";
    tag = finalAttrs.version;
    hash = "sha256-XxZ3h0BtqH+gKZDumrHa13IhZxXQ6ZI5htn6DIislMY=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    chardet
    click
    pyyaml
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tokenizer, operator, character tables, and conversion routines for the Wolfram Language";
    homepage = "https://github.com/Mathics3/Mathics3-scanner";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ VZstless ];
    mainProgram = "mathics3-tokens";
  };
})
