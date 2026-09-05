{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  alsa-lib,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "myx";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "HaseebKhalid1507";
    repo = "Myx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-72Q0AkUT8ms0+zbtVEBjqnku7njUAzVk/Y/d2AyQVeQ=";
  };

  cargoHash = "sha256-aNDKxvz918mwLteGpgQR7cpXs3VK12OHrfm4Q/jT+1s=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    openssl
  ];

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lean, beautiful terminal Spotify player";
    homepage = "https://github.com/HaseebKhalid1507/Myx";
    changelog = "https://github.com/HaseebKhalid1507/Myx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "myx";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ miniharinn ];
  };
})
