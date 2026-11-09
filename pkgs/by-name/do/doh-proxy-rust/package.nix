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
  version = "0.11.1";

  src = fetchCrate {
    inherit (finalAttrs) version;
    crateName = "doh-proxy";
    hash = "sha256-f2C0Tq/qcOtJ72eekNj9LBgDoEjLKGjK1U7VxZo4Wq8=";
  };

  cargoHash = "sha256-BJqD1bsMJMPZvMNKVAbYoApt3zBGKyEfQGqoeAJI+0w=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  passthru.tests = { inherit (nixosTests) doh-proxy-rust; };

  meta = {
    homepage = "https://github.com/jedisct1/doh-server";
    description = "Fast, mature, secure DoH server proxy written in Rust";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stephank ];
    mainProgram = "doh-proxy";
  };
})
