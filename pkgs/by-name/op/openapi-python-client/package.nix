{
  lib,
  stdenv,
  darwin,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  testers,
  openapi-python-client,
}:

python3Packages.buildPythonApplication rec {
  pname = "openapi-python-client";
  version = "0.25.2";
  pyproject = true;

  src = fetchFromGitHub {
    inherit version;
    owner = "openapi-generators";
    repo = "openapi-python-client";
    tag = "v${version}";
    hash = "sha256-B+GVv1Q/OwbtHDMGNYkPkZgvHqncrAkdvZ6ECwhIbLE=";
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

  dependencies = (
    with python3Packages;
    [
      attrs
      httpx
      jinja2
      pydantic
      python-dateutil
      ruamel-yaml
      ruff
      shellingham
      typer
      typing-extensions
    ]
  );
  # openapi-python-client defines upper bounds to the dependencies, ruff python library is
  # just a simple wrapper to locate the binary. We'll remove the upper bound
  pythonRelaxDeps = [ "ruff" ];

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
    changelog = "https://github.com/openapi-generators/openapi-python-client/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    mainProgram = "openapi-python-client";
    maintainers = with lib.maintainers; [ konradmalik ];
  };
}
