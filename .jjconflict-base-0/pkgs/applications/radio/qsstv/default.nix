{
  mkDerivation,
  lib,
  fetchurl,
  qtbase,
  qmake,
  openjpeg,
  pkg-config,
  fftw,
  libpulseaudio,
  alsa-lib,
  hamlib,
  libv4l,
  fftwFloat,
}:

mkDerivation rec {
  version = "9.5.8";
  pname = "qsstv";

  src = fetchurl {
    url = "https://www.qsl.net/o/on4qz/qsstv/downloads/qsstv_${version}.tar.gz";
    sha256 = "0s3sivc0xan6amibdiwfnknrl3248wzgy98w6gyxikl0qsjpygy0";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
  ];

  buildInputs = [
    qtbase
    openjpeg
    fftw
    libpulseaudio
    alsa-lib
    hamlib
    libv4l
    fftwFloat
  ];

  postInstall = ''
    # Install desktop icon
    install -D icons/qsstv.png $out/share/pixmaps/qsstv.png
    install -D qsstv.desktop $out/share/applications/qsstv.desktop
  '';

  meta = with lib; {
    description = "Qt-based slow-scan TV and fax";
    mainProgram = "qsstv";
    homepage = "https://www.qsl.net/on4qz/";
    platforms = platforms.linux;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ hax404 ];
  };
}
