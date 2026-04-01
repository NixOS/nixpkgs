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
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "gotify-desktop";
    rev = finalAttrs.version;
    sha256 = "sha256-BD8BqG+YheAGvHWrI1/PqCs6T3O3OwXodZq3gvgh1LU=";
  };

  cargoHash = "sha256-CHo3TYNpXdU3g7vKEwmubPKy+COSZ9Ay77nW8IlK9H4=";

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
