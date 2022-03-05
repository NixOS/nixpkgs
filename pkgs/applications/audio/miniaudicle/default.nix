{ lib
, stdenv
, fetchurl
, bison
, flex
, which
, alsa-lib
, libsndfile
, qt4
, qscintilla-qt4
, libpulseaudio
, libjack2
, audioBackend ? "pulse" # "pulse", "alsa", or "jack"
}:

stdenv.mkDerivation rec {
  pname = "miniaudicle";
  version = "1.3.5.2";

  src = fetchurl {
    url = "https://audicle.cs.princeton.edu/mini/release/files/miniAudicle-${version}.tgz";
    hash = "sha256-dakDz69uHbKZFj8z67CubmRXEQ5X6GuYqlCXXvLzqSI=";
  };

  sourceRoot = "miniAudicle-${version}/src";

  postPatch = ''
    substituteInPlace miniAudicle.pro \
      --replace "/usr/local" $out
  '';

  nativeBuildInputs = [
    bison
    flex
    which
  ];

  buildInputs = [
    alsa-lib
    libsndfile
    qt4
    qscintilla-qt4
  ] ++ lib.optional (audioBackend == "pulse") libpulseaudio
    ++ lib.optional (audioBackend == "jack")  libjack2;

  buildFlags = [ "linux-${audioBackend}" ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A light-weight integrated development environment for the ChucK digital audio programming language";
    homepage = "https://audicle.cs.princeton.edu/mini/";
    downloadPage = "https://audicle.cs.princeton.edu/mini/linux/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    broken = stdenv.isDarwin; # not attempted
  };
}
