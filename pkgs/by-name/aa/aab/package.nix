{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "aab";
  version = "1.0.0-dev.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glutanimate";
    repo = "anki-addon-builder";
    tag = "v${version}";
    hash = "sha256-92Xqxgb9MLhSIa5EN3Rdk4aJlRfzEWqKmXFe604Q354=";
  };

  patches = [
    ./fix-flaky-tests.patch
    ./only-call-git-when-necessary.patch
    ./allow-manually-setting-modtime.patch
  ];

  build-system = [ python3.pkgs.poetry-core ];

  dependencies = with python3.pkgs; [
    jsonschema
    whichcraft
    pyqt5
    pyqt6
  ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    python3.pkgs.pyqt5
    python3.pkgs.pyqt6
  ];

  pythonImportsCheck = [ "aab" ];

  meta = {
    description = "Build tool for Anki add-ons";
    homepage = "https://github.com/glutanimate/anki-addon-builder";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ eljamm ];
  };
}
