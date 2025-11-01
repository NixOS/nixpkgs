{
  lib,
  fetchFromGitHub,
  installShellFiles,
  php,
  versionCheckHook,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "phpactor";
  version = "2025.10.17.0";

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    tag = finalAttrs.version;
    hash = "sha256-A/ajGQ75z/EdWFFJK0kLjcSFfa9z15TZCNZZpwq9k2E=";
  };

  vendorHash = "sha256-qLcwAmnkh3nxrvdDa/OI3RQOi/4qhxURhcXM1r5iE88=";

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
