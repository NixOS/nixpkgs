{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "graphinder";
  version = "2.0.0b4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Escape-Technologies";
    repo = "graphinder";
    tag = "v${version}";
    hash = "sha256-emBWhEJxYRAw3WTd8t+lurnHX8SeCcLBHGH9B+Owuag=";
  };

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    aiohttp
    beautifulsoup4
    requests
    setuptools
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "graphinder"
  ];

  disabledTests = [
    # Tests require network access
    "test_domain_class"
    "test_extract_file_zip"
    "test_fetch_assets"
    "test_full_run"
    "test_init_domain_tasks"
    "test_is_gql_endpoint"
  ];

  meta = {
    description = "Tool to find GraphQL endpoints using subdomain enumeration";
    homepage = "https://github.com/Escape-Technologies/graphinder";
    changelog = "https://github.com/Escape-Technologies/graphinder/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "graphinder";
  };
}
