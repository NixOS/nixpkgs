{
  lib,
  fetchFromGitHub,
  aspellDicts,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "codespell";
  version = "2.4.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "codespell-project";
    repo = "codespell";
    tag = "v${version}";
    sha256 = "sha256-9hr/QZcBESLukujzNKNjWGG3nXx+wkvQvoUYmYgtXv0=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  nativeCheckInputs = with python3.pkgs; [
    aspell-python
    chardet
    pytestCheckHook
    pytest-cov-stub
    pytest-dependency
  ];

  preCheck = ''
    export ASPELL_CONF="dict-dir ${aspellDicts.en}/lib/aspell"
  '';

  disabledTests = [
    # tries to run not fully installed script
    "test_basic"
  ];

  pythonImportsCheck = [ "codespell_lib" ];

  meta = with lib; {
    description = "Fix common misspellings in source code";
    mainProgram = "codespell";
    homepage = "https://github.com/codespell-project/codespell";
    license = with licenses; [
      gpl2Only
      cc-by-sa-30
    ];
    maintainers = with maintainers; [
      johnazoidberg
      SuperSandro2000
    ];
  };
}
