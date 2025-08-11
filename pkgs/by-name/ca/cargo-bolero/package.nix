{
  lib,
  rustPlatform,
  fetchCrate,
  libbfd,
  libopcodes,
  libunwind,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bolero";
  version = "0.13.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-lfBpHaY2UCBMg45S4IW8fcpkGkKJoT4qqR2yq5KiXuE=";
  };

  cargoHash = "sha256-2URFqLg2aQF7MOpwG6fEPBXyBsLENWpdiXgxW/DJxQE=";

  buildInputs = [
    libbfd
    libopcodes
    libunwind
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Fuzzing and property testing front-end framework for Rust";
    mainProgram = "cargo-bolero";
    homepage = "https://github.com/camshaft/bolero";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ekleog ];
  };
}
