{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-clone";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "janlikar";
    repo = "cargo-clone";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-tAY4MUytFVa7kXLeOg4xak8XKGgApnEGWiK51W/7uDg=";
  };

  cargoHash = "sha256-AFCCXZKm6XmiaayOqvGhMzjyMwAqVK1GZccWHWV5/9c=";

  env.LIBGIT2_NO_VENDOR = 1;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  # requires internet access
  doCheck = false;

  meta = {
    description = "Cargo subcommand to fetch the source code of a Rust crate";
    mainProgram = "cargo-clone";
    homepage = "https://github.com/janlikar/cargo-clone";
    changelog = "https://github.com/janlikar/cargo-clone/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
      janlikar
    ];
  };
})
