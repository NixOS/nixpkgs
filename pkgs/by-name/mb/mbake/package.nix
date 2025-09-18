{
  stdenv,
  lib,
  fetchFromGitHub,
  installShellFiles,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "mbake";
  version = "1.4.1.pre";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EbodShojaei";
    repo = "bake";
    tag = "v${version}";
    hash = "sha256-HbBibwrd73GA0Z3xiYJAu1te7BADqsSkk0d99bMrwPw=";
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
  versionCheckProgramArg = "--version";

  pythonImportsCheck = [ "mbake" ];

  meta = {
    description = "Makefile formatter and linter";
    homepage = "https://github.com/EbodShojaei/bake";
    changelog = "https://github.com/EbodShojaei/bake/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "mbake";
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}
