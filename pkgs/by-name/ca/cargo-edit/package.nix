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
  version = "0.13.6";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-z+LTgCeTUr3D0LEbw0yHlk1di2W95XewbYlgusD2TLg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/+DDA64kemZKzKdaKnXK+R4e8FV59qT5HCGcwyOz7R8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    zlib
  ];

  doCheck = false; # integration tests depend on changing cargo config

  meta = with lib; {
    description = "Utility for managing cargo dependencies from the command line";
    homepage = "https://github.com/killercup/cargo-edit";
    changelog = "https://github.com/killercup/cargo-edit/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      Br1ght0ne
      figsoda
      gerschtli
      jb55
      killercup
      matthiasbeyer
    ];
  };
}
