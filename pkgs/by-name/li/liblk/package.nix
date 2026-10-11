{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "liblk";
  version = "0-unstable-2026-06-30";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "R0rt1z2";
    repo = "liblk";
    rev = "75c8f14f16457b6c53d950d18d1ed7d2a665bed6";
    hash = "sha256-e1YVOvZPbq5JbCzSfR723iBemcueT4XOh2svhTXpYUU=";
  };

  build-system = [
    python3Packages.setuptools
    python3Packages.wheel
  ];

  dependencies = with python3Packages; [
    pyasn1
  ];

  optional-dependencies = with python3Packages; {
    dev = [
      mypy
      pytest
      ruff
    ];
  };

  pythonImportsCheck = [
    "liblk"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiny and simple library to tinker with MediaTek bootloader images (LK)";
    homepage = "https://github.com/R0rt1z2/liblk";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "liblk";
  };
})
