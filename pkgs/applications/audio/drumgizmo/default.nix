{ stdenv, fetchurl, alsaLib, expat, glib, libjack2, libX11, libpng
, libpthreadstubs, libsmf, libsndfile, lv2, pkgconfig, zita-resampler
}:

stdenv.mkDerivation rec {
  version = "0.9.12";
  name = "drumgizmo-${version}";

  src = fetchurl {
    url = "http://www.drumgizmo.org/releases/${name}/${name}.tar.gz";
    sha256 = "0kqrss9v3vpznmh4jgi3783wmprr645s3i485jlvdscpysjfkh6z";
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
