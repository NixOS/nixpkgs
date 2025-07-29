{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
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
  version = "1.2.14";

  src = fetchFromGitHub {
    owner = "gillesdegottex";
    repo = "fmit";
    rev = "v${finalAttrs.version}";
    sha256 = "1q062pfwz2vr9hbfn29fv54ip3jqfd9r99nhpr8w7mn1csy38azx";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    itstool
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    fftw
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
  ]
  ++ lib.optionals alsaSupport [ alsa-lib ]
  ++ lib.optionals jackSupport [ libjack2 ]
  ++ lib.optionals portaudioSupport [ portaudio ];

  postPatch = ''
    substituteInPlace fmit.pro --replace '$$FMITVERSIONGITPRO' '${finalAttrs.version}'
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
    maintainers = with lib.maintainers; [ orivej ];
    platforms = lib.platforms.linux;
  };
})
