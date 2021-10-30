{ mkDerivation, lib, fetchurl, qtbase, qmake, openjpeg, pkg-config, fftw,
  libpulseaudio, alsa-lib, hamlib, libv4l, fftwFloat }:

mkDerivation rec {
  version = "9.4.4";
  pname = "qsstv";

  src = fetchurl {
    url = "http://users.telenet.be/on4qz/qsstv/downloads/qsstv_${version}.tar.gz";
    sha256 = "0f9hx6sy418cb23fadll298pqbc5l2lxsdivi4vgqbkvx7sw58zi";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
  ];

  buildInputs = [ qtbase openjpeg fftw libpulseaudio alsa-lib hamlib libv4l
                  fftwFloat ];

  postInstall = ''
    # Install desktop icon
    install -D qsstv/icons/qsstv.png $out/share/pixmaps/qsstv.png
  '';

  meta = with lib; {
    description = "Qt-based slow-scan TV and fax";
    homepage = "http://users.telenet.be/on4qz/";
    platforms = platforms.linux;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ hax404 ];
  };
}

