{
  lib,
  fetchFromGitHub,
  aspellDicts,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "codespell";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codespell-project";
    repo = "codespell";
    tag = "v${finalAttrs.version}";
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

  meta = {
    description = "Fix common misspellings in source code";
    mainProgram = "codespell";
    homepage = "https://github.com/codespell-project/codespell";
    license = with lib.licenses; [
      gpl2Only
      cc-by-sa-30
    ];
    maintainers = with lib.maintainers; [
      johnazoidberg
      SuperSandro2000
    ];
  };
})
