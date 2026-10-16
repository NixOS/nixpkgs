{
  lib,
  fetchFromGitHub,
  installShellFiles,
  php,
  versionCheckHook,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "phpactor";
  version = "2026.07.22.0";

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    tag = finalAttrs.version;
    hash = "sha256-GDFVzHbuEJSuT6Mg7peBu2WxUrjmF4lgU0fViTJTCCk=";
  };

  vendorHash = "sha256-Cn6D3iSItOx4/owdayMy9Gkf7ChYPzQdDzw7BSGMoWg=";

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
