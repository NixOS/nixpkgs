{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "star-history";
  version = "1.0.33";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-pjUZApvjOUrX1ii07RmGI8rj8BkGHwQj2muQWPhG8k4=";
  };

  cargoHash = "sha256-vSmXI/8LKu9o7O2NJChsK0Y+sy5n68/Y59tzeKJYu7c=";

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
