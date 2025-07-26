{
  lib,
  python3Packages,
  fetchFromGitHub,
  groff,
  nix-update-script,
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

  # cppman pins all dependency versions via requirements.txt as install_requires, causing this check to fail.
  dontCheckRuntimeDeps = true;

  pythonImportsCheck = [
    "cppman"
  ];

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
