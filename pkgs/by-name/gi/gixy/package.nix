{
  lib,
  python3,
  fetchFromGitHub,
  nginx,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gixy-ng";
  version = "0.2.55";
  pyproject = true;

  # Fetching from GitHub because the PyPI sdist is missing the tests
  src = fetchFromGitHub {
    owner = "dvershinin";
    repo = "gixy";
    tag = "v${version}";
    hash = "sha256-0yUWlnH+b3qkSz6Pje71YQaEhhrh5+BsbeCwPpng5J4=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    ngxparse
    jinja2
    configargparse
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  disabledTestPaths = [
    # Requires the optional `redoctor` backend (gixy-ng[deep]), not packaged
    "tests/plugins/test_redos_analyzer.py"
  ];

  pythonImportsCheck = [ "gixy" ];

  passthru = {
    inherit (nginx.passthru) tests;
  };

  meta = {
    description = "Nginx configuration static analyzer focused on security";
    mainProgram = "gixy";
    longDescription = ''
      Gixy is a static analyzer for nginx configurations. Its main
      goal is to detect security misconfigurations and to automate
      the discovery of common flaws (HTTP response splitting, host
      spoofing on virtual-host dispatch, alias-traversal "off-by-
      slash", missing add_header inheritance, weak SSL/TLS ciphers,
      and more).

      Tracks the actively-maintained gixy-ng distribution on PyPI;
      the binary remains `gixy'.
    '';
    homepage = "https://gixy.getpagespeed.com/";
    changelog = "https://github.com/dvershinin/gixy/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ dvershinin ];
    platforms = lib.platforms.unix;
  };
}
