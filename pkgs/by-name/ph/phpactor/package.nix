{
  lib,
  fetchFromGitHub,
  installShellFiles,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpactor";
  version = "2024.11.05.0";

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    rev = finalAttrs.version;
    hash = "sha256-/h7Apqo0N4aQvLfzfV/v35npo1wwOOZksokJKhCp8oA=";
  };

  vendorHash = "sha256-nfy2H6isjW7m0UdPaX9Kqt2iwA2IwOhHE+xmqJ2t1qo=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd phpactor \
    --bash <(php $out/bin/phpactor completion bash)
  '';

  meta = {
    changelog = "https://github.com/phpactor/phpactor/releases/tag/${finalAttrs.version}";
    description = "Mainly a PHP Language Server";
    homepage = "https://github.com/phpactor/phpactor";
    license = lib.licenses.mit;
    mainProgram = "phpactor";
    maintainers = lib.teams.php.members;
  };
})
