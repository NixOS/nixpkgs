{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iw4x-launcher";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "iw4x";
    repo = "launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/7c1RlBq1BrHIGeykkAPWhPTsYRo4KtcNrY2lTtccCw=";
  };

  cargoHash = "sha256-IqtWFsZckeN0r+mF5dw1cxKiJHUuXTDqBB1hu52lE+w=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  env.OPENSSL_NO_VENDOR = true;

  meta = {
    description = "Official launcher for the IW4x mod";
    longDescription = "IW4x allows you to relive Call of Duty: Modern Warfare 2 (2009) in a secure environment with expanded modding capabilites";
    homepage = "https://iw4x.dev";
    downloadPage = "https://github.com/iw4x/launcher";
    changelog = "https://github.com/iw4x/launcher/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ andrewfield ];
    mainProgram = "iw4x-launcher";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
