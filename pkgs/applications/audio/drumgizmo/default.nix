{ stdenv, fetchurl, fetchpatch, alsaLib, expat, glib, libjack2, libXext, libX11, libpng
, libpthreadstubs, libsmf, libsndfile, lv2, pkgconfig, zita-resampler
}:

stdenv.mkDerivation rec {
  version = "0.9.18.1";
  pname = "drumgizmo";

  src = fetchurl {
    url = "https://www.drumgizmo.org/releases/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "0bpbkzcr3znbwfdk79c14n5k5hh80iqlk2nc03q95vhimbadk8k7";
  };

  patches = [
    # Fix build for lv2 1.18.0
    (fetchpatch {
      url = "http://cgit.drumgizmo.org/plugingizmo.git/patch/?id=be64ddf9da525cd5c6757464efc966052731ba71";
      sha256 = "17w8g78i5avssc7m8rpw64ka3rai8dff81wfzir9cpxp8s2h44qf";
      extraPrefix = "plugin/plugingizmo/";
      stripLen = 1;
    })
  ];

  configureFlags = [ "--enable-lv2" ];

  buildInputs = [
    alsaLib expat glib libjack2 libXext libX11 libpng libpthreadstubs
    libsmf libsndfile lv2 pkgconfig zita-resampler
  ];

  meta = with stdenv.lib; {
    description = "An LV2 sample based drum plugin";
    homepage = "https://www.drumgizmo.org";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.nico202 ];
  };
}
