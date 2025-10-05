{
  lib,
  fetchFromGitHub,
  installShellFiles,
  php,
  versionCheckHook,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "phpactor";
  version = "2025.07.25.0";

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    tag = finalAttrs.version;
    hash = "sha256-9XWlWwq+xvqPgKIc7IGoMVTxajjYsrPo/ra/0JIE168=";
  };

  vendorHash = "sha256-3xkt0QjytW4BOCgZdevat7zkSuZTPPvwz3yptiq5zoo=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd phpactor \
    --bash <(php $out/bin/phpactor completion bash)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/phpactor/phpactor/releases/tag/${finalAttrs.version}";
    description = "Mainly a PHP Language Server";
    homepage = "https://github.com/phpactor/phpactor";
    license = lib.licenses.mit;
    mainProgram = "phpactor";
    maintainers = [ lib.maintainers.patka ];
  };
})
