{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  bison,
  flex,
  libsndfile,
  which,
  DarwinTools,
  xcbuild,
  AppKit,
  Carbon,
  CoreAudio,
  CoreMIDI,
  CoreServices,
  Kernel,
  MultitouchSupport,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chuck";
  version = "1.5.5.0";

  src = fetchurl {
    url = "http://chuck.cs.princeton.edu/release/files/chuck-${finalAttrs.version}.tgz";
    hash = "sha256-jjWBCtTBybFy5+YZgPRJaUOW/AQAu1Zij69Px4f46gY=";
  };

  nativeBuildInputs =
    [
      flex
      bison
      which
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      DarwinTools
      xcbuild
    ];

  buildInputs =
    [ libsndfile ]
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) alsa-lib
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      AppKit
      Carbon
      CoreAudio
      CoreMIDI
      CoreServices
      Kernel
      MultitouchSupport
    ];

  makeFlags = [
    "-C src"
    "DESTDIR=$(out)/bin"
  ];

  buildFlags = [ (if stdenv.hostPlatform.isDarwin then "mac" else "linux-alsa") ];

  meta = {
    description = "Programming language for real-time sound synthesis and music creation";
    homepage = "http://chuck.cs.princeton.edu";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ftrvxmtrx ];
    mainProgram = "chuck";
  };
})
