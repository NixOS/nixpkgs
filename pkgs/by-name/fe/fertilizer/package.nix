{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "fertilizer";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "moleculekayak";
    repo = "fertilizer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dPTR3GfofXBV1gwQ8Xdl8Dyz23CU9qBLAahwpxj8z+Q=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    bencoder
    colorama
    flask
    requests
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "fertilizer" ];

  meta = {
    description = "Cross-seeding tool for music";
    homepage = "https://github.com/moleculekayak/fertilizer";
    changelog = "https://github.com/moleculekayak/fertilizer/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "fertilizer";
  };
})
