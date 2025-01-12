{
  lib,
  fetchFromGitHub,
  aspellDicts,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "codespell";
  version = "2.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "codespell-project";
    repo = "codespell";
    rev = "v${version}";
    sha256 = "sha256-X3Pueu0E7Q57sbKSXqCZki4/PUb1WyWk/Zmj+lhVTM8=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools-scm
  ];

  nativeCheckInputs = with python3Packages; [
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
