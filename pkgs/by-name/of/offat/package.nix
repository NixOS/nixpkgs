{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "offat";
  version = "0.17.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OWASP";
    repo = "OFFAT";
    rev = "refs/tags/v${version}";
    hash = "sha256-tyQoTc/cfzYxK+vLg9TvZdbKRX3B4tL1Do/wDMArJSA=";
  };

  sourceRoot = "${src.name}/src";

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

  passthru.optional-dependencies = {
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

  meta = with lib; {
    description = "Tool to test APIs for prevalent vulnerabilities";
    homepage = "https://github.com/OWASP/OFFAT/";
    changelog = "https://github.com/OWASP/OFFAT/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "offat";
  };
}
