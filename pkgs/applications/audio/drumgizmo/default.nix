{ stdenv, fetchurl, alsaLib, expat, glib, libjack2, libXext, libX11, libpng
, libpthreadstubs, libsmf, libsndfile, lv2, pkgconfig, zita-resampler
}:

stdenv.mkDerivation rec {
  version = "0.9.17";
  pname = "drumgizmo";

  src = fetchurl {
    url = "https://www.drumgizmo.org/releases/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "177c27kz9srds7a659zz9yhp58z0zsk0ydwww7l3jkjlylm1p8x1";
  };

  configureFlags = [ "--enable-lv2" ];

  buildInputs = [
    alsaLib expat glib libjack2 libXext libX11 libpng libpthreadstubs
    libsmf libsndfile lv2 pkgconfig zita-resampler
  ];

  meta = with stdenv.lib; {
    description = "An LV2 sample based drum plugin";
    homepage = https://www.drumgizmo.org;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.nico202 ];
  };
}
