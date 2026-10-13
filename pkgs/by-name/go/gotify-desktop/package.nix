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
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "gotify-desktop";
    rev = finalAttrs.version;
    sha256 = "sha256-bKLqe02/KnSjeho7SYAiN2k3YY4XMpjLCZfWJngTIOQ=";
  };

  cargoHash = "sha256-IgenG3xPxo4JRzQ/F3pxrYM4KiPU0TfFYc32TDT8rag=";

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
