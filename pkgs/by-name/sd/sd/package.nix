{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sd";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = "sd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HK53+1oH3EJm4Tg6BhLtG575FlBREb0OCetIQuCsBNc=";
  };

  cargoHash = "sha256-iOCIX7hq8RqRihVQrVoU2qCTSziuJePxsexkDSCZS9c=";

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
    ];
  };
})
