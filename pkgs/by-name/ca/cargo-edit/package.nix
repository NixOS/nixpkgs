{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-edit";
  version = "0.13.8";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = "cargo-edit";
    rev = "v${version}";
    hash = "sha256-+CWCWhdb7S4QSNAfzL2+YMTF7oKQvk18NSxSSTQtQBc=";
  };

  cargoHash = "sha256-D2klo0arp1Gv6y1a1lCM3Ht4nAirkao/Afu7FE3CTbg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    zlib
  ];

  doCheck = false; # integration tests depend on changing cargo config

  meta = {
    description = "Utility for managing cargo dependencies from the command line";
    homepage = "https://github.com/killercup/cargo-edit";
    changelog = "https://github.com/killercup/cargo-edit/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      Br1ght0ne
      gerschtli
      jb55
      killercup
      matthiasbeyer
    ];
  };
}
