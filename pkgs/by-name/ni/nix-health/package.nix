{
  lib,
  stdenv,
  rustPlatform,
  fetchCrate,
  libiconv,
  openssl,
  pkg-config,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-health";
  version = "0.4.0";

  src = fetchCrate {
    inherit version;
    pname = "nix_health";
    hash = "sha256-/I6LdcH61wgJOEv51J1jkWlD8BlSAaRR1e7gc5H9bQI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3DE/NwPdi//7xaoV2SVgF5l3ndrEYraoyg5NLJzvzBI=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      libiconv
      openssl
    ]
    # Use a newer SDK for CoreFoundation, because the sysinfo crate requires
    # it, https://github.com/GuillaumeGomez/sysinfo/issues/915
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk_11_0.frameworks;
      [
        IOKit
        CoreFoundation
      ]
    );

  meta = with lib; {
    description = "Check the health of your Nix setup";
    homepage = "https://github.com/juspay/nix-health";
    license = licenses.asl20;
    maintainers = with maintainers; [ shivaraj-bh ];
    mainProgram = "nix-health";
  };
}
