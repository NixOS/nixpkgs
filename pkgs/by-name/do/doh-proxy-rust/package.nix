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
  version = "0.10.0";

  src = fetchCrate {
    inherit (finalAttrs) version;
    crateName = "doh-proxy";
    hash = "sha256-dRff1YWDqSf9naRkwPAX5GeLYIwlUD481+/TWnsM/p4=";
  };

  cargoHash = "sha256-YtcfOr7RseVRTgyQq43tQ8GWhLpOW2pQeReCBD+Ez6c=";

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
