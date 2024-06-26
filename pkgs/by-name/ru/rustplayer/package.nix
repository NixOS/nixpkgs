{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, alsa-lib
, ffmpeg_4
}:

rustPlatform.buildRustPackage {
  pname = "rustplayer";
  version = "unstable-2022-12-29";

  src = fetchFromGitHub {
    owner = "Kingtous";
    repo = "RustPlayer";
    rev = "a369bc19ab4a8c568c73be25c5e6117e1ee5d848";
    sha256 = "sha256-x82EdA7ezCzux1C85IcI2ZQ3M95sH6/k97Rv6lqc5eo=";
  };

  # This patch is from the source
  patches = [
    ./dynamic-lib.patch
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ffmpeg-sys-next-4.4.0" = "sha256-TBgf+J+ud7nnVjf0r98/rujFPEayjEaVi+vnSE6/5Ak=";
    };
  };
  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];
  buildInputs = [ alsa-lib openssl ffmpeg_4 ];

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
