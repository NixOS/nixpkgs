{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "offat";
  version = "0.19.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OWASP";
    repo = "OFFAT";
    tag = "v${version}";
    hash = "sha256-XFYG8/QJfm9fx88xHBXe3hK6rTj1lVQze/X9joxKZuc=";
  };

  sourceRoot = "${src.name}/src";

  pythonRelaxDeps = [
    "rich"
    "setuptools"
    "tenacity"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    aiohttp
    aiolimiter
    fastapi
    openapi-spec-validator
    requests
    rich
    setuptools
    tenacity
  ];

  optional-dependencies = {
    api = with python3.pkgs; [
      fastapi
      uvicorn
      redis
      rq
      python-dotenv
    ];
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "offat" ];

  meta = {
    description = "Tool to test APIs for prevalent vulnerabilities";
    homepage = "https://github.com/OWASP/OFFAT/";
    changelog = "https://github.com/OWASP/OFFAT/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "offat";
  };
}
