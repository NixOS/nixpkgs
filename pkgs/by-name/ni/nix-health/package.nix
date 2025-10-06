{
  lib,
  rustPlatform,
  fetchCrate,
  libiconv,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-health";
  version = "0.4.0";

  src = fetchCrate {
    inherit version;
    pname = "nix_health";
    hash = "sha256-/I6LdcH61wgJOEv51J1jkWlD8BlSAaRR1e7gc5H9bQI=";
  };

  cargoHash = "sha256-3DE/NwPdi//7xaoV2SVgF5l3ndrEYraoyg5NLJzvzBI=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libiconv
    openssl
  ];

  meta = with lib; {
    description = "Check the health of your Nix setup";
    homepage = "https://github.com/juspay/nix-health";
    license = licenses.asl20;
    maintainers = with maintainers; [ shivaraj-bh ];
    mainProgram = "nix-health";
  };
}
