{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  fftw,
  itstool,
  alsaSupport ? true,
  alsa-lib ? null,
  jackSupport ? false,
  libjack2 ? null,
  portaudioSupport ? false,
  portaudio ? null,
}:

assert alsaSupport -> alsa-lib != null;
assert jackSupport -> libjack2 != null;
assert portaudioSupport -> portaudio != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "fmit";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "gillesdegottex";
    repo = "fmit";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fi5/JCgum+TYexUuTRZNFWPPsR87P73gfYhozQYx3Rw=";
  };

  nativeBuildInputs = [
    qt6.qmake
    itstool
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    fftw
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtsvg
  ]
  ++ lib.optionals alsaSupport [ alsa-lib ]
  ++ lib.optionals jackSupport [ libjack2 ]
  ++ lib.optionals portaudioSupport [ portaudio ];

  postPatch = ''
    substituteInPlace fmit.pro \
      --replace-fail 'FMITVERSIONPRO = $$system(git describe --tags --always)' 'FMITVERSIONPRO = ${finalAttrs.version}' \
      --replace-fail 'FMITBRANCHGITPRO = $$system(git rev-parse --abbrev-ref HEAD)' 'FMITBRANCHGITPRO = master'
  '';

  qmakeFlags = [
    "PREFIXSHORTCUT=${placeholder "out"}"
  ]
  ++ lib.optionals alsaSupport [
    "CONFIG+=acs_alsa"
  ]
  ++ lib.optionals jackSupport [
    "CONFIG+=acs_jack"
  ]
  ++ lib.optionals portaudioSupport [
    "CONFIG+=acs_portaudio"
  ];

  meta = {
    description = "Free Musical Instrument Tuner";
    longDescription = ''
      FMIT is a graphical utility for tuning musical instruments, with error
      and volume history, and advanced features.
    '';
    homepage = "http://gillesdegottex.github.io/fmit/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
