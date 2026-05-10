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
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "patryk-ku";
    repo = "music-discord-rpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HZh7rwZR/9dccNyQV2BEyQF2vtoH+L/lW4L4hu9RJTI=";
  };

  cargoHash = "sha256-vCqjeY07R/AuNruBYS3sc7n9kN/Y4IwvvpSooWTu7Oc=";

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
