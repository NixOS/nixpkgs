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
  version = "0.13.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-xU7a5xEFSrFsQ1K5DIYgACuf+34QeCvGmWvlSSwI03I=";
  };

  cargoHash = "sha256-FMpM42D3h42NfDzH+EVs6NB2RVehFNFAYTMvzRQVt/s=";

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
