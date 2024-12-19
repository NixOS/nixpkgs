{
  lib,
  fetchFromGitHub,
  python3,
}:
let
  python = python3.override {
    self = python;
    packageOverrides = _: super: {
      cattrs = super.cattrs.overridePythonAttrs (oldAttrs: rec {
        version = "23.1.2";
        build-system = [ super.poetry-core ];
        src = oldAttrs.src.override {
          rev = "refs/tags/v${version}";
          hash = "sha256-YO4Clbo5fmXbysxwwM2qCHJwO5KwDC05VctRVFruJcw=";
        };
      });
    };
  };
in

python.pkgs.buildPythonApplication rec {
  pname = "openllm";
  version = "0.6.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bentoml";
    repo = "openllm";
    rev = "refs/tags/v${version}";
    hash = "sha256-4KIpe6KjbBDDUj0IjzSccxjgZyBoaUVIQJYk1+W01Vo=";
  };

  pythonRemoveDeps = [
    "pathlib"
    "pip-requirements-parser"
  ];

  pythonRelaxDeps = [ "openai" ];

  build-system = with python.pkgs; [
    hatch-vcs
    hatchling
  ];

  dependencies = with python.pkgs; [
    accelerate
    bentoml
    dulwich
    nvidia-ml-py
    openai
    psutil
    pyaml
    questionary
    tabulate
    typer
    uv
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "openllm" ];

  meta = with lib; {
    description = "Run any open-source LLMs, such as Llama 3.1, Gemma, as OpenAI compatible API endpoint in the cloud";
    homepage = "https://github.com/bentoml/OpenLLM";
    changelog = "https://github.com/bentoml/OpenLLM/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      happysalada
      natsukium
    ];
    mainProgram = "openllm";
  };
}
