{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gtk3,
  openssl,
  alsa-lib,
  pkg-config,
  ffmpeg,
  dbus,
  libpulseaudio,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "songrec";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = "songrec";
    rev = finalAttrs.version;
    hash = "sha256-pTonrxlYvfuLRKMXW0Lao4KCoNFlMzE9rH+hwpa60JY=";
  };

  cargoHash = "sha256-wSRn1JY067RVqGGdiox87+zRb2/2OMcvKLYZE1QUs/s=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    dbus
    gtk3
    openssl
    ffmpeg
    libpulseaudio
  ];

  postInstall = ''
    mv packaging/rootfs/usr/share $out/share
  '';

  meta = {
    description = "Open-source Shazam client for Linux, written in Rust";
    homepage = "https://github.com/marin-m/SongRec";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tcbravo ];
    mainProgram = "songrec";
  };
})
