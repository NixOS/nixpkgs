{
  lib,
  stdenv,
  darwin,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  ruff,
  testers,
  openapi-python-client,
}:

python3Packages.buildPythonApplication rec {
  pname = "openapi-python-client";
  version = "0.21.5";
  pyproject = true;

  src = fetchFromGitHub {
    inherit version;
    owner = "openapi-generators";
    repo = "openapi-python-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-/m/XXNqsr0FjYSEGMSw4zIUpWJDOqu9BzNuJKyb7fKY=";
  };

  nativeBuildInputs =
    [
      installShellFiles
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.ps
    ];

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies =
    (with python3Packages; [
      attrs
      httpx
      jinja2
      pydantic
      python-dateutil
      ruamel-yaml
      shellingham
      typer
      typing-extensions
    ])
    ++ [ ruff ];

  # ruff is not packaged as a python module in nixpkgs
  pythonRemoveDeps = [ "ruff" ];

  postInstall = ''
    # see: https://github.com/fastapi/typer/blob/5889cf82f4ed925f92e6b0750bf1b1ed9ee672f3/typer/completion.py#L54
    # otherwise shellingham throws exception on darwin
    export _TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION=1
    installShellCompletion --cmd openapi-python-client \
      --bash <($out/bin/openapi-python-client --show-completion bash) \
      --fish <($out/bin/openapi-python-client --show-completion fish) \
      --zsh <($out/bin/openapi-python-client --show-completion zsh)
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = openapi-python-client;
    };
  };

  meta = {
    description = "Generate modern Python clients from OpenAPI";
    homepage = "https://github.com/openapi-generators/openapi-python-client";
    changelog = "https://github.com/openapi-generators/openapi-python-client/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "openapi-python-client";
    maintainers = with lib.maintainers; [ konradmalik ];
  };
}
