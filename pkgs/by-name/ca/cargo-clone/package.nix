{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-clone";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "janlikar";
    repo = "cargo-clone";
    rev = "v${version}";
    sha256 = "sha256-tAY4MUytFVa7kXLeOg4xak8XKGgApnEGWiK51W/7uDg=";
  };

  cargoHash = "sha256-AFCCXZKm6XmiaayOqvGhMzjyMwAqVK1GZccWHWV5/9c=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    zlib
  ];

  # requires internet access
  doCheck = false;

  meta = {
    description = "Cargo subcommand to fetch the source code of a Rust crate";
    mainProgram = "cargo-clone";
    homepage = "https://github.com/janlikar/cargo-clone";
    changelog = "https://github.com/janlikar/cargo-clone/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
      janlikar
    ];
  };
}
