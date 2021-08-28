{ lib, stdenv, fetchFromGitHub, autoreconfHook, intltool, pkg-config, ffmpeg, wxGTK30-gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "spek";
  version = "unstable-2018-12-29";

  src = fetchFromGitHub {
    owner = "alexkay";
    repo = "spek";
    rev = "f071c2956176ad53c7c8059e5c00e694ded31ded";
    sha256 = "1l9gj9c1n92zlcjnyjyk211h83dk0idk644xnm5rs7q40p2zliy5";
  };

  # needed for autoreconfHook
  AUTOPOINT="intltoolize --automake --copy";

  nativeBuildInputs = [ autoreconfHook intltool pkg-config wrapGAppsHook ];

  buildInputs = [ ffmpeg wxGTK30-gtk3 wxGTK30-gtk3.gtk ];

  meta = with lib; {
    description = "Analyse your audio files by showing their spectrogram";
    homepage = "http://spek.cc/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.all;
  };
}
