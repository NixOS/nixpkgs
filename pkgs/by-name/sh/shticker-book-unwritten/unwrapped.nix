{
  rustPlatform,
  fetchCrate,
  aws-lc,
  pkg-config,
  openssl,
  lib,

  withSecretStore ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shticker-book-unwritten";
  version = "1.3.1";

  src = fetchCrate {
    inherit (finalAttrs) version;
    crateName = "shticker_book_unwritten";
    hash = "sha256-omQfnKJQomB2Am5m0yIGaEdu8MaDcUmlq+2OOBEi4bw=";
  };

  cargoHash = "sha256-fWp+8wiqqmJoM2mTu7AYqOa9dOS0gidXiKIs2Z63jK4=";

  buildFeatures = lib.optionals withSecretStore [ "secret-store" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    aws-lc
    openssl
  ];
})
