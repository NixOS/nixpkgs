{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  libiconv,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "doh-proxy-rust";
  version = "0.9.16";

  src = fetchCrate {
    inherit (finalAttrs) version;
    crateName = "doh-proxy";
    hash = "sha256-V/mWMKBsCStQovgvMtRP66+OsNF2TC0GarYY51C/Zik=";
  };

  cargoHash = "sha256-daXXjD789tJBph00FPlm2C5gW3jwcTTAZ5TVeDJz8lU=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  passthru.tests = { inherit (nixosTests) doh-proxy-rust; };

  meta = {
    homepage = "https://github.com/jedisct1/doh-server";
    description = "Fast, mature, secure DoH server proxy written in Rust";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ stephank ];
    mainProgram = "doh-proxy";
  };
})
