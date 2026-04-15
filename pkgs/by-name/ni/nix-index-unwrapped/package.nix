{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  curl,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-index";
  version = "0.1.9-unstable-2026-02-05";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-index";
    rev = "8c84f67a33c4c26ec12f166cb5f63a77fafebe21";
    hash = "sha256-8ZMKtBbsBPbccEWH1XHCYsxXX4hckHXwQNr5OzGrU0Q=";
  };

  cargoHash = "sha256-0yrTPrxN/4TOALqpQ5GW7LXKisc8msx3DvEpg8uO+IQ=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    curl
    sqlite
  ];

  postInstall = ''
    substituteInPlace command-not-found.sh \
      --subst-var out
    install -Dm555 command-not-found.sh -t $out/etc/profile.d
    substituteInPlace command-not-found.nu \
      --subst-var out
    install -Dm555 command-not-found.nu -t $out/etc/profile.d
  '';

  meta = {
    description = "Files database for nixpkgs";
    homepage = "https://github.com/nix-community/nix-index";
    changelog = "https://github.com/nix-community/nix-index/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [
      bennofs
      ncfavier
    ];
    mainProgram = "nix-index";
  };
})
