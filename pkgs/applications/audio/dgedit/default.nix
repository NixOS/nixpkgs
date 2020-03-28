{ stdenv
, lib
, fetchgit
, pkg-config
, autoreconfHook
, libao
, libsndfile
, qtbase
, qtx11extras
, qttools
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "dgedit";
  version = "0.10.0";

  src = fetchgit {
    url = "git://git.drumgizmo.org/dgedit.git/";
    rev = "v${version}";
    sha256 = "11mcfa6h61q0gk0ynfpqql4lnih0m3y2z9mdjq4p1219hrapxs5q";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config autoreconfHook wrapQtAppsHook ];
  buildInputs = [ qtbase qtx11extras qttools libao libsndfile ];

  meta = with lib; {
    description = "the DrumGizmo drumkit editor";
    homepage = "https://drumgizmo.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.matthiasbeyer ];
  };
}
