{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  wrapQtAppsHook,
  qt6Packages,
  bison,
  flex,
  which,
  alsa-lib,
  libsndfile,
  libpulseaudio,
  libjack2,
  audioBackend ? "pulse", # "pulse", "alsa", or "jack"
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "miniaudicle";
  version = "1.5.4.2";

  src = fetchFromGitHub {
    owner = "ccrma";
    repo = "miniAudicle";
    rev = "chuck-${finalAttrs.version}";
    hash = "sha256-LYr9Fc4Siqk0BFKHVXfIV2XskJYAN+/0P+nb6FJLsLE=";
    fetchSubmodules = true;
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  postPatch = ''
    echo '#define GIT_REVISION "${finalAttrs.version}-NixOS"' > git-rev.h
    substituteInPlace miniAudicle.pro \
      --replace-fail "/usr/local" $out
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
    qt6Packages.qscintilla
  ]
  ++ lib.optional (audioBackend == "pulse") libpulseaudio
  ++ lib.optional (audioBackend == "jack") libjack2;

  buildFlags = [ "linux-${audioBackend}" ];

  meta = with lib; {
    description = "Light-weight integrated development environment for the ChucK digital audio programming language";
    mainProgram = "miniAudicle";
    homepage = "https://audicle.cs.princeton.edu/mini/";
    downloadPage = "https://audicle.cs.princeton.edu/mini/linux/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # not attempted
  };
})
