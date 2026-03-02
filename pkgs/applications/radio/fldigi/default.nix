{
  lib,
  stdenv,
  fetchurl,
  hamlib,
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

stdenv.mkDerivation rec {
  pname = "fldigi";
  version = "4.2.11";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-dis3D/6crnc6KgO1EtC3JC5+kEB8EdWrvS0xrmUBZk8=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxinerama
    gettext
    hamlib
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
      ftrvxmtrx
    ];
    platforms = lib.platforms.unix;
  };
}
