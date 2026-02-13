{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  alsa-lib,
  dbus,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qobuz-player";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "SofusA";
    repo = "qobuz-player";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LStCoBr3BblXRpuno+QKxyJstvrNmP+wub61491NkPY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "mpris-server-0.9.0" = "sha256-dwiFDhY48oHPzFxFrUO0DhOX1RdXrweGAdhBUIDj+Wg=";
      "qonductor-0.1.0" = "sha256-bDELIAkOsU8QM1S7BlfRt7soy6ZNGBh7atxjHNAK4dY=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    alsa-lib
    dbus
    openssl
  ];

  env.SQLX_OFFLINE = "true";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Music player for Qobuz";
    homepage = "https://github.com/SofusA/qobuz-player";
    changelog = "https://github.com/SofusA/qobuz-player/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jordansteinke ];
    mainProgram = "qobuz-player";
    platforms = lib.platforms.linux;
  };
})
