{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "arsenal";
  version = "1.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Orange-Cyberdefense";
    repo = "arsenal";
    tag = finalAttrs.version;
    sha256 = "sha256-C8DEB/xojU7vGvmeBF+PBD6KWMaJgwa7PpRS5+YzQ6c=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    libtmux
    docutils
    pyfzf
    pyperclip
    pyyaml
  ];

  nativeCheckInputs = [ versionCheckHook ];

  pythonImportsCheck = [
    "arsenal"
  ];

  meta = {
    description = "Tool to generate commands for security and network tools";
    homepage = "https://github.com/Orange-Cyberdefense/arsenal";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "arsenal";
  };
})
