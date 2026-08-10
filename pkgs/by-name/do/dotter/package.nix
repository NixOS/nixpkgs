{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  which,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dotter";
  version = "0.13.5";

  src = fetchFromGitHub {
    owner = "SuperCuber";
    repo = "dotter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xA/6j+wMTPx9p4aOHaqixlzUZcqgRazfJ1PwKaByTrw=";
  };

  cargoHash = "sha256-0yBuaTwP2IxZjRzC8jMhZ8eNDdFHKyJjSP0ZH15F3LI=";

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

  meta = {
    description = "Dotfile manager and templater written in Rust";
    homepage = "https://github.com/SuperCuber/dotter";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ linsui ];
    mainProgram = "dotter";
  };
})
