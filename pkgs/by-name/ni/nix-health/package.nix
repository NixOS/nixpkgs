{
  lib,
  rustPlatform,
  fetchCrate,
  libiconv,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-health";
  version = "0.4.0";

  src = fetchCrate {
    inherit (finalAttrs) version;
    pname = "nix_health";
    hash = "sha256-/I6LdcH61wgJOEv51J1jkWlD8BlSAaRR1e7gc5H9bQI=";
  };

  cargoHash = "sha256-3DE/NwPdi//7xaoV2SVgF5l3ndrEYraoyg5NLJzvzBI=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libiconv
    openssl
  ];

  meta = {
    description = "Check the health of your Nix setup";
    homepage = "https://github.com/juspay/nix-health";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shivaraj-bh ];
    mainProgram = "nix-health";
  };
})
