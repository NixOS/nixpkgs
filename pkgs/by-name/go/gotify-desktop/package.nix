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
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "gotify-desktop";
    rev = finalAttrs.version;
    sha256 = "sha256-d7JSNkVkOE03C/c1VeqKAbJezr/cCGhqgpA7OsMFhx4=";
  };

  cargoHash = "sha256-l3G3pRfUkfipU/eM5el9AlNTi2YcTC60Woeb7Xi1+r0=";

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
