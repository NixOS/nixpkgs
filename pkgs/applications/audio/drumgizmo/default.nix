{ stdenv, fetchurl, alsaLib, expat, glib, libjack2, libXext, libX11, libpng
, libpthreadstubs, libsmf, libsndfile, lv2, pkgconfig, zita-resampler
}:

stdenv.mkDerivation rec {
  version = "0.9.15";
  name = "drumgizmo-${version}";

  src = fetchurl {
    url = "https://www.drumgizmo.org/releases/${name}/${name}.tar.gz";
    sha256 = "13bgqyw74pq3ss63zd9bjmgr4dah792pcphyqmr7bnvrgfjr6bx6";
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
