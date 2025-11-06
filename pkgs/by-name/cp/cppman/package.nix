{
  lib,
  python3Packages,
  fetchFromGitHub,
  groff,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "cppman";
  version = "0.5.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aitjcize";
    repo = "cppman";
    tag = version;
    hash = "sha256-iPJR4XAjNrBhFHZVOATPi3WwTC1/Y6HK3qmKLqbaK98=";
  };

  build-system = with python3Packages; [
    setuptools
    distutils
  ];

  dependencies = [
    python3Packages.beautifulsoup4
    python3Packages.html5lib
    python3Packages.lxml
    python3Packages.six
    python3Packages.soupsieve
    python3Packages.typing-extensions
    python3Packages.webencodings
    groff
  ];

  # cppman pins all dependency versions via requirements.txt as install_requires
  pythonRelaxDeps = true;

  # bs4 is merely a dummy package and can be safely removed
  # Ideally, its version would also stay fixed.
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace-fail "bs4==0.0.2" ""
  '';

  pythonImportsCheck = [
    "cppman"
  ];

  nativeCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  # Writable $HOME is required for `cppman --version` to work
  versionCheckKeepEnvironment = "HOME";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal viewer for C++ 98/11/14 manual pages";
    homepage = "https://github.com/aitjcize/cppman";
    changelog = "https://github.com/aitjcize/cppman/blob/${src.tag}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ryan4yin ];
    mainProgram = "cppman";
  };
}
