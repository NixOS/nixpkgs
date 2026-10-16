{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nodezator";
  version = "1.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "IndieSmiths";
    repo = "nodezator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9lEizhTwihv909xDgmcel9eCL7VfVDrWDtWghdjSH90=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pygame-ce
    numpy
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generalist Python node editor";
    homepage = "https://nodezator.com";
    downloadPage = "https://github.com/IndieSmiths/nodezator";
    changelog = "https://github.com/IndieSmiths/nodezator/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "nodezator";
  };
})
