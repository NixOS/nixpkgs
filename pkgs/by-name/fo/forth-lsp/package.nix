{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "forth-lsp";
  version = "0.8.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AlexanderBrevig";
    repo = "forth-lsp";
    rev = "38078e5dda88ab20ef6c3b4575f64b154a9f11a8";
    hash = "sha256-5NlWlByZOU9VZ99RWpW0x8kTnymrsTPnjiRREZk0jig=";
  };

  cargoHash = "sha256-wLS6JhagnwUjDLgVOMostZl+f+cPscqE5TsPrHiykKI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "LSP for the Forth programming language";
    homepage = "https://github.com/AlexanderBrevig/forth-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ricardomaps ];
    mainProgram = "forth-lsp";
    platforms = lib.platforms.unix;
  };
})
