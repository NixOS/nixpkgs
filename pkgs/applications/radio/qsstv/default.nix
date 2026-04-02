{
  lib,
  stdenv,
  fetchurl,
  qtbase,
  qmake,
  openjpeg,
  pkg-config,
  wrapQtAppsHook,
  fftw,
  libpulseaudio,
  alsa-lib,
  hamlib,
  libv4l,
  fftwFloat,
  imagemagick,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "9.5.8";
  pname = "qsstv";

  src = fetchurl {
    url = "https://www.qsl.net/o/on4qz/qsstv/downloads/qsstv_${finalAttrs.version}.tar.gz";
    sha256 = "0s3sivc0xan6amibdiwfnknrl3248wzgy98w6gyxikl0qsjpygy0";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
    wrapQtAppsHook
    imagemagick
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
    mkdir -p $out/share/icons/hicolor/32x32/apps
    magick icons/qsstv.png -resize 32x32 $out/share/icons/hicolor/32x32/apps/qsstv.png
    install -D qsstv.desktop $out/share/applications/qsstv.desktop
  '';

  meta = {
    description = "Qt-based slow-scan TV and fax";
    mainProgram = "qsstv";
    homepage = "https://www.qsl.net/on4qz/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ hax404 ];
  };
})
