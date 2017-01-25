{ stdenv, fetchurl, alsaLib, expat, glib, libjack2, libX11, libpng
, libpthreadstubs, libsmf, libsndfile, lv2, pkgconfig, zita-resampler
}:

stdenv.mkDerivation rec {
  version = "0.9.11";
  name = "drumgizmo-${version}";

  src = fetchurl {
    url = "http://www.drumgizmo.org/releases/${name}/${name}.tar.gz";
    sha256 = "04hf3nhccwr98n2081rrvfccz50nly6k3gbk9zxccp1522qz5xvf";
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
