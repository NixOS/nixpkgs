{
  lib,
  fetchFromGitHub,
  installShellFiles,
  php,
  versionCheckHook,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "phpactor";
<<<<<<< HEAD
  version = "2025.12.21.0";
=======
  version = "2025.10.17.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-wMyHkkN15kd2Q9BN3H2gJ3iNlRodric2DqWiWLU1Fj0=";
  };

  vendorHash = "sha256-T4YiYL2RBpmLluk5rm4hkpD96wXKmrlX/1pzHRb//68=";
=======
    hash = "sha256-A/ajGQ75z/EdWFFJK0kLjcSFfa9z15TZCNZZpwq9k2E=";
  };

  vendorHash = "sha256-qLcwAmnkh3nxrvdDa/OI3RQOi/4qhxURhcXM1r5iE88=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd phpactor \
    --bash <(php $out/bin/phpactor completion bash)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    changelog = "https://github.com/phpactor/phpactor/releases/tag/${finalAttrs.version}";
    description = "Mainly a PHP Language Server";
    homepage = "https://github.com/phpactor/phpactor";
    license = lib.licenses.mit;
    mainProgram = "phpactor";
    maintainers = [ lib.maintainers.patka ];
  };
})
