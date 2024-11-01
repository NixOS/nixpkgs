{ lib, stdenv
, rustPlatform
, fetchCrate
, libiconv
, openssl
, pkg-config
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-health";
  version = "0.4.0";

  src = fetchCrate {
    inherit version;
    pname = "nix_health";
    hash = "sha256-/I6LdcH61wgJOEv51J1jkWlD8BlSAaRR1e7gc5H9bQI=";
  };

  cargoHash = "sha256-mqJA5Fv/sYj6ZkE73emtaHvg9hdT/5lN0kM3sl+GRCo=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libiconv openssl ]
    # Use a newer SDK for CoreFoundation, because the sysinfo crate requires
    # it, https://github.com/GuillaumeGomez/sysinfo/issues/915
    ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk_11_0.frameworks;
      [ IOKit
        CoreFoundation
      ]);

  meta = with lib; {
    description = "Check the health of your Nix setup";
    homepage = "https://github.com/juspay/nix-health";
    license = licenses.asl20;
    maintainers = with maintainers; [ srid shivaraj-bh ];
    mainProgram = "nix-health";
  };
}
