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
  version = "0.13.7";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = "cargo-edit";
    rev = "v${version}";
    hash = "sha256-doNQzXB+tW+5UI3PCuZo8aZErsXeafL6lldi/yXyBhs=";
  };

  cargoHash = "sha256-N3Q3rK9GsVf9mI9SFqF7lnU8CWxmueDCgBjP6n9dUoY=";

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
      figsoda
      gerschtli
      jb55
      killercup
      matthiasbeyer
    ];
  };
}
