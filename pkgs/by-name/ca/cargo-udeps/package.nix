{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.57";

  src = fetchFromGitHub {
    owner = "est31";
    repo = "cargo-udeps";
    rev = "v${version}";
    sha256 = "sha256-08IUMw/fCVrmsSL4a86dAbeG+DsS2d7jiVBNKfebVqk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cHQIW3TDxurrkT9FfGCBVG4PRgTg5+XkLXgnDL1rfG0=";

  nativeBuildInputs = [ pkg-config ];

  # TODO figure out how to use provided curl instead of compiling curl from curl-sys
  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
    ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "Find unused dependencies in Cargo.toml";
    homepage = "https://github.com/est31/cargo-udeps";
    license = licenses.mit;
    maintainers = with maintainers; [
      b4dm4n
      matthiasbeyer
    ];
    mainProgram = "cargo-udeps";
  };
}
