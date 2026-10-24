{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "star-history";
  version = "1.0.34";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-IySnZbB7eydt3xV0JzVPeiR/CkSYEZ0HGH7Kdmuq5rc=";
  };

  cargoHash = "sha256-xvchzi95XCx5SIK2VYOIQFGGJ2pa2Q8RAKOAracqsuY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Command line program to generate a graph showing number of GitHub stars of a user, org or repo over time";
    homepage = "https://github.com/dtolnay/star-history";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ lib.maintainers.matthiasbeyer ];
    mainProgram = "star-history";
  };
})
