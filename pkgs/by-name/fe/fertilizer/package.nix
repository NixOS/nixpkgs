{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "fertilizer";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "moleculekayak";
    repo = "fertilizer";
    tag = "v${version}";
    hash = "sha256-sDoAjEiKxHf+HtFLZr6RwuXN+rl0ZQnFUoQ09QiE6Xc=";
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
}
