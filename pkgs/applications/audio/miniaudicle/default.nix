{ lib
, stdenv
, fetchFromGitHub
, qmake
, wrapQtAppsHook
, qscintilla-qt6
, bison
, flex
, which
, alsa-lib
, libsndfile
, libpulseaudio
, libjack2
, audioBackend ? "pulse" # "pulse", "alsa", or "jack"
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "miniaudicle";
  version = "1.5.0.7";

  src = fetchFromGitHub {
    owner = "ccrma";
    repo = "miniAudicle";
    rev = "chuck-${finalAttrs.version}";
    hash = "sha256-CqsajNLcOp7CS5RsVabWM6APnNh4alSKb2/eoZ7F4Ao=";
    fetchSubmodules = true;
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  postPatch = ''
    echo '#define GIT_REVISION "${finalAttrs.version}-NixOS"' > git-rev.h
    substituteInPlace miniAudicle.pro \
      --replace "/usr/local" $out
  '';

  nativeBuildInputs = [
    bison
    flex
    which
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    libsndfile
    qscintilla-qt6
  ] ++ lib.optional (audioBackend == "pulse") libpulseaudio
    ++ lib.optional (audioBackend == "jack")  libjack2;

  buildFlags = [ "linux-${audioBackend}" ];

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
