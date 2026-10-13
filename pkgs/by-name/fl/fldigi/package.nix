{
  lib,
  stdenv,
  fetchurl,
  hamlib_4,
  fltk_1_3,
  libjpeg,
  libpng,
  portaudio,
  libsndfile,
  libsamplerate,
  libpulseaudio,
  libxinerama,
  gettext,
  pkg-config,
  alsa-lib,
  udev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fldigi";
  version = "4.2.13";

  src = fetchurl {
    url = "mirror://sourceforge/${finalAttrs.pname}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-oejZkDWc6cDM4861EW/Qz3LJVSiWl2aJhkDKbKLbqNQ=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxinerama
    gettext
    hamlib_4
    fltk_1_3
    libjpeg
    libpng
    portaudio
    libsndfile
    libsamplerate
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    libpulseaudio
    alsa-lib
    udev
  ];

  env.CXXFLAGS = lib.concatStringsSep " " (
    lib.optionals stdenv.cc.isClang [
      "-std=c++14"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-Wno-error=unguarded-availability"
    ]
  );

  enableParallelBuilding = true;

  meta = {
    description = "Digital modem program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      relrod
    ];
    platforms = lib.platforms.unix;
  };
})
