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
  version = "0.13.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-73TjQYkSng93tryaZpBtwq3MdVYZC8enEibx6yTdEKw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-0T7KyTQ5kJ4mv5lLxYeo7hxLjSkrmjfenrNV+7GL1hM=";

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
