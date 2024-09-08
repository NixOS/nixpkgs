{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  darwin,
  which,
  installShellFiles,
}:

rustPlatform.buildRustPackage {
  pname = "dotter";
  version = "0.13.2-unstable-2024-08-02";

  src = fetchFromGitHub {
    owner = "SuperCuber";
    repo = "dotter";
    rev = "d5199df24e6db039c460fa37fe3279f89c3bfc63";
    hash = "sha256-8/drsrJq8mfrWvTCcNX0eoPHzywxQNuyRdxQE/zb8lA=";
  };

  cargoHash = "sha256-+LBmswq2mvM0hb6wwCQMxL+C/TdpRGZQGufgsqC1KSQ=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.CoreServices ];

  nativeCheckInputs = [
    which
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd dotter \
      --bash <($out/bin/dotter gen-completions --shell bash) \
      --fish <($out/bin/dotter gen-completions --shell fish) \
      --zsh <($out/bin/dotter gen-completions --shell zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Dotfile manager and templater written in rust 🦀";
    homepage = "https://github.com/SuperCuber/dotter";
    license = licenses.unlicense;
    maintainers = with maintainers; [ linsui ];
    mainProgram = "dotter";
  };
}
