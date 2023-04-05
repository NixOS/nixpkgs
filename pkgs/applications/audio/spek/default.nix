{ lib, stdenv, fetchFromGitHub, autoreconfHook, intltool, pkg-config, ffmpeg_4, wxGTK32, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "spek";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "alexkay";
    repo = "spek";
    rev = "v${version}";
    sha256 = "sha256-JLQx5LlnVe1TT1KVO3/QSVRqYL+pAMCxoDWrnkUNmRU=";
  };

  nativeBuildInputs = [ autoreconfHook intltool pkg-config wrapGAppsHook ];

  buildInputs = [ ffmpeg_4 wxGTK32 gtk3 ];

  meta = with lib; {
    description = "Analyse your audio files by showing their spectrogram";
    homepage = "http://spek.cc/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.all;
  };
}
