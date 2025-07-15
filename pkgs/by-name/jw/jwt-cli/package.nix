{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  installShellFiles,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "jwt-cli";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "mike-engel";
    repo = "jwt-cli";
    tag = version;
    hash = "sha256-2pYCNLopvIHcKiN4qewQCdkGWHYQ6vQVCaApxGsRG9E=";
  };

  cargoHash = "sha256-lp2I5+zvFM46TmejtNn/qgVlAaL+xL9slZHduccO/5Q=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd jwt \
      --bash <($out/bin/jwt completion bash) \
      --fish <($out/bin/jwt completion fish) \
      --zsh <($out/bin/jwt completion zsh)
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/jwt --version > /dev/null
    $out/bin/jwt decode eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c \
      | grep -q 'John Doe'
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Super fast CLI tool to decode and encode JWTs";
    homepage = "https://github.com/mike-engel/jwt-cli";
    changelog = "https://github.com/mike-engel/jwt-cli/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rycee ];
    mainProgram = "jwt";
  };
}
