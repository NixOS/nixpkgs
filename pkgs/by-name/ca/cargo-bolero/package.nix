{ lib, rustPlatform, fetchCrate, libbfd, libopcodes, libunwind, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bolero";
  version = "0.11.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Xcu91CbIDBLSojWQJjvdFWJiqjMteAxF105lemCAipk=";
  };

  cargoHash = "sha256-QLtf42Il+XHWeaUdh8jNNWU1sXaVe82sYOKiHLoXw2M=";

  buildInputs = [ libbfd libopcodes libunwind ];

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
