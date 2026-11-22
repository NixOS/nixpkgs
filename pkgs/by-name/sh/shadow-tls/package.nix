{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shadow-tls";
  version = "0.2.25";

  src = fetchFromGitHub {
    owner = "ihciah";
    repo = "shadow-tls";
    rev = "v${finalAttrs.version}";
    hash = "sha256-T+GPIrcME6Wq5sdfIt4t426/3ew5sUQMykYeZ6zw1ko=";
  };

  cargoPatches = [
    # TODO: remove once upstream updates webpki
    #  webpki-roots 0.26.0 -> 1.0.11
    ./update-webpki.patch
  ];

  cargoHash = "sha256-F11IlCYP4t92rvoGeogcLkVh2geDpHu1AMhyciQ0IeE=";

  env.RUSTC_BOOTSTRAP = 1;

  # network required
  doCheck = false;

  meta = {
    homepage = "https://github.com/ihciah/shadow-tls";
    description = "Proxy to expose real tls handshake to the firewall";
    license = lib.licenses.mit;
    mainProgram = "shadow-tls";
    maintainers = with lib.maintainers; [ oluceps ];
    platforms = lib.platforms.linux;
  };
})
