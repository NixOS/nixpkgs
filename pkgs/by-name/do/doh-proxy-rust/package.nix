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
  version = "0.9.15";

  src = fetchCrate {
    inherit (finalAttrs) version;
    crateName = "doh-proxy";
    hash = "sha256-uqFqDaq5a9wW46pTLfVN+5WuyYGvm3ZYQCtC6jkG1kg=";
  };

  cargoHash = "sha256-eYhax+TM3N75qj0tyHioUeUt159ZfkuFFIZK1jUbojw=";

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
