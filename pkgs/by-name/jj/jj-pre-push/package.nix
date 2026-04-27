{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,

  withPrecommit ? true,
  pre-commit,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "jj-pre-push";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "acarapetis";
    repo = "jj-pre-push";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LULCTpsxTflqWm5ZVFHbnTI/2+4xI9MX4kbAtYzBIAI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "typer-slim" "typer"
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.2,<0.11.0" "uv_build"
  '';

  build-system = with python3Packages; [ uv-build ];

  dependencies =
    with python3Packages;
    [
      typer
    ]
    ++ lib.optionals withPrecommit [ pre-commit ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd jj-pre-push \
      --bash <($out/bin/jj-pre-push --show-completion bash) \
      --fish <($out/bin/jj-pre-push --show-completion fish) \
      --zsh <($out/bin/jj-pre-push --show-completion zsh)
  '';

  pythonImportsCheck = [ "jj_pre_push" ];

  meta = {
    description = "Run pre-commit.com before `jj git push`";
    homepage = "https://github.com/acarapetis/jj-pre-push";
    changelog = "https://github.com/acarapetis/jj-pre-push/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xanderio ];
    mainProgram = "jj-pre-push";
  };
})
