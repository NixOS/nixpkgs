{ stdenv, fetchurl, alsaLib, expat, glib, libjack2, libX11, libpng
, libpthreadstubs, libsmf, libsndfile, lv2, pkgconfig, zita-resampler
}:

stdenv.mkDerivation rec {
  version = "0.9.8.1";
  name = "drumgizmo-${version}";

  src = fetchurl {
    url = "http://www.drumgizmo.org/releases/${name}/${name}.tar.gz";
    sha256 = "1plfjhwhaz1mr3kgf5imcp3kjflk6ni9sq39gmxjxzya6gn2r6gg";
  };

  configureFlags = [ "--enable-lv2" ];

  buildInputs = [
    alsaLib expat glib libjack2 libX11 libpng libpthreadstubs libsmf
    libsndfile lv2 pkgconfig zita-resampler
  ];

  meta = with stdenv.lib; {
    description = "An LV2 sample based drum plugin";
    homepage = http://www.drumgizmo.org;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.nico202 ];
  };
}
