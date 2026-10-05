{
  lib,
  rustPlatform,
  fetchCrate,
  libbfd,
  libopcodes,
  libunwind,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-bolero";
  version = "0.13.5";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-UHbGriOOLyZtsfuuYrgd0W3hdz+feScAt7k4ahrZYRA=";
  };

  cargoHash = "sha256-h6MyYHxPH5IVUWqIPYUcNxcqxtNy5fxM5J1AdrO8Vis=";

  buildInputs = [
    libbfd
    libopcodes
    libunwind
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fuzzing and property testing front-end framework for Rust";
    mainProgram = "cargo-bolero";
    homepage = "https://github.com/camshaft/bolero";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ekleog ];
  };
})
