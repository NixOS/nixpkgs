{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mitmproxy2swagger";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alufers";
    repo = "mitmproxy2swagger";
    tag = version;
    hash = "sha256-bQ9zjRsMrC/B118iP2hevj2hhSFD7FTnsCe6lUMwYSI=";
  };

  pythonRelaxDeps = [
    "mitmproxy"
    "ruamel.yaml"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    json-stream
    mitmproxy
    ruamel-yaml
  ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [ "mitmproxy2swagger" ];

  meta = {
    description = "Tool to automagically reverse-engineer REST APIs";
    homepage = "https://github.com/alufers/mitmproxy2swagger";
    changelog = "https://github.com/alufers/mitmproxy2swagger/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mitmproxy2swagger";
  };
}
