{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "bypass-url-parser";
  version = "0.4.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "laluka";
    repo = "bypass-url-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wQb1sokcmluWIwUn03T3NhJ4qyrcvOzg8iWwHyjQE9s=";
  };

  build-system = with python3.pkgs; [ pdm-backend ];

  dependencies = with python3.pkgs; [
    colorama
    coloredlogs
    docopt-ng
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
    changelog = "https://github.com/laluka/bypass-url-parser/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "bypass-url-parser";
  };
})
