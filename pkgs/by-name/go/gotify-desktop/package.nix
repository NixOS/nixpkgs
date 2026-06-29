{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gotify-desktop";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "gotify-desktop";
    rev = finalAttrs.version;
    sha256 = "sha256-m60VMyuiiDIJy4q0IXUvlIL4m+5UgNWJrxsTXOo/irw=";
  };

  cargoHash = "sha256-E201NGu153EWXj2gUqfCW7BfzcAWPdsifMLWLKVxDkw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Small Gotify daemon to send messages as desktop notifications";
    homepage = "https://github.com/desbma/gotify-desktop";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      genofire
    ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "gotify-desktop";
  };
})
