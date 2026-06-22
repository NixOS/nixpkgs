{
  lib,
  fetchFromGitHub,
  installShellFiles,
  php,
  versionCheckHook,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "phpactor";
  version = "2026.05.30.2";

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    tag = finalAttrs.version;
    hash = "sha256-NUXB5utQWZeVsvMt42KzuLytIRNXf6Pw9mHmhRT33FA=";
  };

  vendorHash = "sha256-6irw/pnTWZvhYEp+aqh3jkp3YktfE31wUgkd1OD6vL4=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd phpactor \
    --bash <(php $out/bin/phpactor completion bash)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/phpactor/phpactor/releases/tag/${finalAttrs.version}";
    description = "Mainly a PHP Language Server";
    homepage = "https://github.com/phpactor/phpactor";
    license = lib.licenses.mit;
    mainProgram = "phpactor";
    maintainers = [ lib.maintainers.patka ];
  };
})
