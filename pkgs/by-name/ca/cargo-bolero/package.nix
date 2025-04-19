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
  version = "0.13.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-X8C4bNGjJx1VxE5X7ntIsbpMPKHVLU1HSQb7vRdivdg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-z1JxoJ4D9GRDsD08kn0WZgaqgTmdL57MgwQ+vFghIpY=";

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
