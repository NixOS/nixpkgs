{
  lib,
  fetchFromGitHub,
  installShellFiles,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "phpactor";
  version = "2024.03.09.0";

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    rev = finalAttrs.version;
    hash = "sha256-1QPBq8S3mOkSackXyCuFdoxfAdUQaRuUfoOfKOGuiR0=";
  };

  vendorHash = "sha256-9YN+fy+AvNnF0Astrirpewjmh/bSINAhW9fLvN5HGGI=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd phpactor \
      --bash <($out/bin/phpactor completion bash)
  '';

  meta = {
    changelog = "https://github.com/phpactor/phpactor/releases/tag/${finalAttrs.version}";
    description = "Mainly a PHP Language Server";
    homepage = "https://github.com/phpactor/phpactor";
    license = lib.licenses.mit;
    mainProgram = "phpactor";
    maintainers = [ lib.maintainers.patka ] ++ lib.teams.php.members;
  };
})
