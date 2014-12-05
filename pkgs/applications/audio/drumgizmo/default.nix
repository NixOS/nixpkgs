{ stdenv, fetchurl, alsaLib, expat, glib, jack2, libX11, libpng
, libpthreadstubs, libsmf, libsndfile, lv2, pkgconfig
}:

stdenv.mkDerivation rec {
  version = "0.9.6";
  name = "drumgizmo-${version}";

  src = fetchurl {
    url = "http://www.drumgizmo.org/releases/${name}/${name}.tar.gz";
    sha256 = "1qs8aa1v8cw5zgfzcnr2dc4w0y5yzsgrywlnx2hfvx2si3as0mw4";
  };

  configureFlags = [ "--enable-lv2" ];

  buildInputs = [
    alsaLib expat glib jack2 libX11 libpng libpthreadstubs libsmf
    libsndfile lv2 pkgconfig
  ];

  meta = with stdenv.lib; {
    description = "An LV2 sample based drum plugin";
    homepage = http://www.drumgizmo.org;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
