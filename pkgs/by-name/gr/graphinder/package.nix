{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "graphinder";
  version = "1.11.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Escape-Technologies";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-TDc6aIFkxShlfC6fLYMKULfrFUAYhQZrIHZNDuMh68g=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
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

  meta = with lib; {
    description = "Tool to find GraphQL endpoints using subdomain enumeration";
    mainProgram = "graphinder";
    homepage = "https://github.com/Escape-Technologies/graphinder";
    changelog = "https://github.com/Escape-Technologies/graphinder/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
