{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  alsa-lib,
  libxmp,
  AudioUnit,
  CoreAudio,
}:

stdenv.mkDerivation rec {
  pname = "xmp";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "libxmp";
    repo = "xmp-cli";
    rev = "${pname}-${version}";
    hash = "sha256-037k1rFjGR6XFtr08bzs4zVz+GyUGuuutuWFlNEuATA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs =
    [ libxmp ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      AudioUnit
      CoreAudio
    ];

  meta = with lib; {
    description = "Extended module player";
    homepage = "https://xmp.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "xmp";
  };
}
