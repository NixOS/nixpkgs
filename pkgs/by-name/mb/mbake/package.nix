{
  stdenv,
  lib,
  fetchFromGitHub,
  installShellFiles,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mbake";
  version = "1.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EbodShojaei";
    repo = "bake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZUcSEWwPR9w/xD+xbaQcKf+4QNwUu3WXMxXvkUm4+SQ=";
  };

  build-system = [
    installShellFiles
    python3Packages.hatchling
  ];

  dependencies = with python3Packages; [
    rich
    typer
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mbake \
      --bash <($out/bin/mbake completions bash) \
      --fish <($out/bin/mbake completions fish) \
      --zsh <($out/bin/mbake completions zsh)
  '';

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    versionCheckHook
  ];

  pythonImportsCheck = [ "mbake" ];

  meta = {
    description = "Makefile formatter and linter";
    homepage = "https://github.com/EbodShojaei/bake";
    changelog = "https://github.com/EbodShojaei/bake/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "mbake";
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
})
