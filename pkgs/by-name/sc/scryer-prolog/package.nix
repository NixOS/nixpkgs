{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "scryer-prolog";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "mthom";
    repo = "scryer-prolog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RCz4zLbmWgSRR6Y5YbhidIZ1+LNR6FHyk/G0ifSDOx4=";
  };

  cargoHash = "sha256-8uFxCLKa8hnGPpilxtV5SxHUG4Nf704A0qG2zpoIK4s=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  CARGO_FEATURE_USE_SYSTEM_LIBS = true;

  meta = {
    description = "Modern Prolog implementation written mostly in Rust";
    mainProgram = "scryer-prolog";
    homepage = "https://github.com/mthom/scryer-prolog";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [
      malbarbo
      wkral
    ];
  };
})
