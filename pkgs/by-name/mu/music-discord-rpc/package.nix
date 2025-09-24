{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  openssl,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "music-discord-rpc";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "patryk-ku";
    repo = "music-discord-rpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+MSrGrnjkyLTCqQiSC2OIGAMgA2oLFqvUtud0kwTTGA=";
  };

  cargoHash = "sha256-Waw/7ErijLSq1RYtjlmtjP8vHYl3wXmRAXvGvH3wOZA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    openssl
  ];

  postInstall = ''
    mkdir --parents $out/etc/systemd/user
    substitute music-discord-rpc.service $out/etc/systemd/user/music-discord-rpc.service \
      --replace-fail /usr/bin/music-discord-rpc $out/bin/music-discord-rpc
  '';

  meta = {
    description = "Cross-platform Discord rich presence for music with album cover and progress bar support";
    homepage = "https://github.com/patryk-ku/music-discord-rpc";
    changelog = "https://github.com/patryk-ku/music-discord-rpc/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lukaswrz ];
    mainProgram = "music-discord-rpc";
  };
})
