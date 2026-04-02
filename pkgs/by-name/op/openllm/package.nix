{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "openllm";
  version = "0.6.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bentoml";
    repo = "openllm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uFisSbWF7Gec7Fthts45kvFnA4aGkzYppt4t8o12Fak=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling==1.27.0" "hatchling" \
      --replace-fail "hatch-vcs==0.4.0" "hatch-vcs"
  '';

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
  ];

  pythonRelaxDeps = [
    "bentoml"
    "openai"
  ];

  dependencies = with python3Packages; [
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

  pythonImportsCheck = [ "openllm" ];

  # No python tests
  nativeCheckInputs = [
    versionCheckHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # PermissionError: [Errno 1] Operation not permitted: '/var/empty/.openllm'
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = lib.optionals stdenv.hostPlatform.isDarwin [ "HOME" ];

  meta = {
    description = "Run any open-source LLMs, such as Llama 3.1, Gemma, as OpenAI compatible API endpoint in the cloud";
    homepage = "https://github.com/bentoml/OpenLLM";
    changelog = "https://github.com/bentoml/OpenLLM/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      happysalada
      natsukium
    ];
    mainProgram = "openllm";
  };
})
