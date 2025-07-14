{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "bypass-url-parser";
  version = "0.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "laluka";
    repo = "bypass-url-parser";
    tag = "v${version}";
    hash = "sha256-h9+kM2LmfPaaM7MK6lK/ARrArwvRn6d+3BW+rNTkqzA=";
  };

  build-system = with python3.pkgs; [ pdm-backend ];

  dependencies = with python3.pkgs; [
    coloredlogs
    docopt
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pythonImportsCheck = [ "bypass_url_parser" ];

  preCheck = ''
    # Some tests need the binary
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # Tests require network access
    "test_sample_usage"
    "test_sample_cli_usage"
  ];

  meta = {
    description = "Tool that tests URL bypasses to reach a 40X protected page";
    homepage = "https://github.com/laluka/bypass-url-parser";
    changelog = "https://github.com/laluka/bypass-url-parser/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "bypass-url-parser";
  };
}
