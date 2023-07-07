{ lib
, stdenv
, fetchFromGitHub
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

stdenv.mkDerivation (finalAttrs: {
  pname = "miniaudicle";
  version = "1.4.2.0";

  src = fetchFromGitHub {
    owner = "ccrma";
    repo = "miniAudicle";
    rev = "miniAudicle-${finalAttrs.version}";
    hash = "sha256-NENpqgCCGiVzVE6rYqBu2RwkzWSiGHe7dZVwBfSomEo=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/src";

  postPatch = ''
    echo '#define GIT_REVISION "${finalAttrs.version}-NixOS"' > git-rev.h
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
})
