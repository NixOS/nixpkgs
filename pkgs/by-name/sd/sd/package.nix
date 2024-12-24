{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "sd";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hC4VKEgrAVuqOX7b24XhtrxrnJW5kmlX4E6QbY9H8OA=";
  };

  cargoHash = "sha256-IhCuWCaSU7c7Tot4uvxE7oabY69wDLstuBN35OzkQcU=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage gen/sd.1

    installShellCompletion gen/completions/sd.{bash,fish}
    installShellCompletion --zsh gen/completions/_sd
  '';

  meta = {
    description = "Intuitive find & replace CLI (sed alternative)";
    mainProgram = "sd";
    homepage = "https://github.com/chmln/sd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      amar1729
      Br1ght0ne
    ];
  };
}
