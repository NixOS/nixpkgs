{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "kimi-cli";
  version = "0.52";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MoonshotAI";
    repo = "kimi-cli";
    rev = version;
    hash = "sha256-HlMxBI/6bldYLEAbcazGplL1q1oUv10dBH6EN8yRP6k=";
  };

  build-system = [ python3.pkgs.uv-build ];
  pythonRelaxDeps = true;

  dependencies = with python3.pkgs; [
    agent-client-protocol-python-sdk
    aiofiles
    aiohttp
    typer
    kosong
    loguru
    patch-ng
    prompt-toolkit
    pillow
    pyyaml
    rich
    ripgrepy
    streamingjson
    trafilatura
    tenacity
    fastmcp
    pydantic
    httpx
  ];

  pythonImportsCheck = [ "kimi_cli" ];

  meta = {
    description = "CLI agent that can help you with your software development tasks and terminal operations";
    homepage = "https://github.com/MoonshotAI/kimi-cli";
    changelog = "https://github.com/MoonshotAI/kimi-cli/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jinser ];
    mainProgram = "kimi";
  };
}
