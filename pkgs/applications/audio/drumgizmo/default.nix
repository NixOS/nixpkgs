{ stdenv, fetchurl, alsaLib, expat, glib, libjack2, libX11, libpng
, libpthreadstubs, libsmf, libsndfile, lv2, pkgconfig, zita-resampler
}:

stdenv.mkDerivation rec {
  version = "0.9.9";
  name = "drumgizmo-${version}";

  src = fetchurl {
    url = "http://www.drumgizmo.org/releases/${name}/${name}.tar.gz";
    sha256 = "03dnh2p4s6n107n0r86h9j1jwy85a8qwjkh0288k60qpdqy1c7vp";
  };

  configureFlags = [ "--enable-lv2" ];

  buildInputs = [
    alsaLib expat glib libjack2 libX11 libpng libpthreadstubs libsmf
    libsndfile lv2 pkgconfig zita-resampler
  ];

  meta = with stdenv.lib; {
    description = "An LV2 sample based drum plugin";
    homepage = http://www.drumgizmo.org;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.nico202 ];
  };
}
