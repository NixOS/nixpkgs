{
  lib,
  fetchFromGitHub,
  python3,
  versionCheckHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "arsenal";
  version = "1.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Orange-Cyberdefense";
    repo = "arsenal";
    tag = version;
    sha256 = "sha256-C8DEB/xojU7vGvmeBF+PBD6KWMaJgwa7PpRS5+YzQ6c=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    libtmux
    docutils
    pyfzf
    pyperclip
    pyyaml
  ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

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
}
