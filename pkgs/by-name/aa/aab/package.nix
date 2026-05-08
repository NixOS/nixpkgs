{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "aab";
  version = "1.0.0-dev.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glutanimate";
    repo = "anki-addon-builder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-92Xqxgb9MLhSIa5EN3Rdk4aJlRfzEWqKmXFe604Q354=";
  };

  patches = [
    ./fix-flaky-tests.patch
    ./only-call-git-when-necessary.patch
    ./allow-manually-setting-modtime.patch
  ];

  build-system = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    jsonschema
    whichcraft
    pyqt5
    pyqt6
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    python3Packages.pyqt5
    python3Packages.pyqt6
  ];

  pythonImportsCheck = [ "aab" ];

  meta = {
    description = "Build tool for Anki add-ons";
    homepage = "https://github.com/glutanimate/anki-addon-builder";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ eljamm ];
  };
})
