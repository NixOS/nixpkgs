{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  alsa-lib,
  cmake,
  libjack2,
  lhasa,
  makeWrapper,
  pkg-config,
  rtmidi,
  SDL2,
  zlib,
  zziplib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "milkytracker";
  version = "1.05.01";

  src = fetchFromGitHub {
    owner = "milkytracker";
    repo = "MilkyTracker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-31Jy93bQj9wZ9vWJe5DVnBqFXfPSH1qmk8kcT/t+FY0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs =
    [
      lhasa
      libjack2
      rtmidi
      SDL2
      zlib
      zziplib
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
    ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 $src/resources/milkytracker.desktop $out/share/applications/milkytracker.desktop
    install -Dm644 $src/resources/pictures/carton.png $out/share/pixmaps/milkytracker.png
    install -Dm644 $src/resources/org.milkytracker.MilkyTracker.metainfo.xml $out/share/appdata/org.milkytracker.MilkyTracker.metainfo.xml
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Music tracker application, similar to Fasttracker II";
    homepage = "https://milkytracker.org/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    # ibtool -> real Xcode -> I can't get that, and Ofborg can't test that
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    mainProgram = "milkytracker";
  };
})
