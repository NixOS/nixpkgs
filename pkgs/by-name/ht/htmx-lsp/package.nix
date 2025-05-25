{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "htmx-lsp";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ThePrimeagen";
    repo = "htmx-lsp";
    rev = version;
    hash = "sha256-CvQ+vgo3+qUOj0SS6/NrapzXkP98tpiZbGhRHJxEqeo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-EQHNFiyQ7TwY4LldMFOTX0epilU76LPOiHQIIUsNhS8=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Language server implementation for htmx";
    homepage = "https://github.com/ThePrimeagen/htmx-lsp";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
    mainProgram = "htmx-lsp";
  };
}
