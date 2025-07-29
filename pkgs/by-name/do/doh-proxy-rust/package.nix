{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  libiconv,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "doh-proxy-rust";
  version = "0.9.12";

  src = fetchCrate {
    inherit version;
    crateName = "doh-proxy";
    hash = "sha256-Q+SjUB9XQlT+r1bjKJooqJ095yp5PMqMAQhoo+kp238=";
  };

  cargoHash = "sha256-XEHeGduKsIFW0tXto8DcghzNYMGE/zkWY2cTg8ZcPcU=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  passthru.tests = { inherit (nixosTests) doh-proxy-rust; };

  meta = with lib; {
    homepage = "https://github.com/jedisct1/doh-server";
    description = "Fast, mature, secure DoH server proxy written in Rust";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ stephank ];
    mainProgram = "doh-proxy";
  };
}
