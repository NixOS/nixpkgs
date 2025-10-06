{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  alsa-lib,
  ffmpeg_6,
}:

rustPlatform.buildRustPackage {
  pname = "rustplayer";
  version = "1.1.2-unstable-2024-07-14";

  src = fetchFromGitHub {
    owner = "Kingtous";
    repo = "RustPlayer";
    rev = "29a16f01912bc3e92008c7ae2f9569c8d7250bd3";
    hash = "sha256-+36dLp54rfNK0lSSTG5+J6y51NUtBhtwfhD7L23J5aY=";
  };

  # This patch is from the source
  patches = [
    ./dynamic-lib.patch
  ];

  cargoHash = "sha256-cfr5q44SzJ5iYm8cu/3+RkoPaoUklmOV/UbSdZZbu38=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];
  buildInputs = [
    alsa-lib
    openssl
    ffmpeg_6
  ];

  checkFlags = [
    # network required
    "--skip=fetch_and_play"
  ];

  meta = with lib; {
    homepage = "https://github.com/Kingtous/RustPlayer";
    description = "Local audio player and network m3u8 radio player using a terminal interface";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ oluceps ];
    platforms = platforms.unix;
  };
}
