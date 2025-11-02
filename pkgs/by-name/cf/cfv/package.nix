{
  lib,
  fetchFromGitHub,
  python3,
  pkgs,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cfv";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cfv-project";
    repo = "cfv";
    tag = "v${version}";
    sha256 = "sha256-vKlnW6Z0Rg2bptU5fxIKDaOY2b+WY/fgaYZQu5tBU44=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  checkPhase = ''
    runHook preCheck
    cd test
    ulimit -n 4096
    python3 test.py
    runHook postCheck
  '';

  nativeCheckInputs = [
    pkgs.cksfv
  ];

  meta = {
    description = "Utility to verify and create a wide range of checksums";
    homepage = "https://github.com/cfv-project/cfv";
    changelog = "https://github.com/cfv-project/cfv/releases/tag/v${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jjtt ];
    mainProgram = "cfv";
  };
}
