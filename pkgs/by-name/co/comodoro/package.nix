{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  withTcp ? true,
  clang_20,
}:
rustPlatform.buildRustPackage rec {
  pname = "comodoro";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "soywod";
    repo = "comodoro";
    rev = "v${version}";
    hash = "sha256-FnNNJ6WHR8KCsW+1hPIYddxQlUvpPc+SRbaxAcdVEUk=";
  };

  cargoHash = "sha256-2Drty/dj9HCG86rPt4RgexU83vKMnGFETbOT11Puy/0=";

  nativeBuildInputs =
    lib.optional (installManPages || installShellCompletions) installShellFiles
    ++ lib.optional stdenv.isDarwin [ clang_20 ];

  # Enable upstream default features to include hooks.
  buildNoDefaultFeatures = false;
  buildFeatures = lib.optional withTcp "tcp";

  postInstall =
    lib.optionalString installManPages ''
      mkdir -p $out/man
      $out/bin/comodoro manual $out/man
      installManPage $out/man/*
    ''
    + lib.optionalString installShellCompletions ''
      installShellCompletion --cmd comodoro \
        --bash <($out/bin/comodoro completion bash) \
        --fish <($out/bin/comodoro completion fish) \
        --zsh <($out/bin/comodoro completion zsh)
    '';

  meta = {
    description = "CLI to manage your time";
    homepage = "https://github.com/pimalaya/comodoro";
    changelog = "https://github.com/soywod/comodoro/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soywod ];
    mainProgram = "comodoro";
  };
}
