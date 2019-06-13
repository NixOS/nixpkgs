{ stdenv, fetchsvn, makeWrapper, pkgconfig, cmake, qtbase, cairo, pixman,
boost, cups, fontconfig, freetype, hunspell, libjpeg, libtiff, libxml2, lcms2,
podofo, poppler, poppler_data, python2, harfbuzz, qtimageformats, qttools }:

let
  pythonEnv = python2.withPackages(ps: [ps.tkinter ps.pillow]);
  revision = "22806";
in 
stdenv.mkDerivation rec {
  name = "scribus-unstable-${version}";
  version = "2019-01-16";

  src = fetchsvn {
    url = "svn://scribus.net/trunk/Scribus";
    rev = revision;
    sha256 = "16xpsbp6kca78jf48n6zdmyjras38xr11paan839hgy4ik83ncn0";
  };

  enableParallelBuilding = true;

  buildInputs = [
    makeWrapper pkgconfig cmake qtbase cairo pixman boost cups fontconfig
    freetype hunspell libjpeg libtiff libxml2 lcms2 podofo poppler
    poppler_data pythonEnv harfbuzz qtimageformats qttools
  ];

  postFixup = ''
    wrapProgram $out/bin/scribus \
      --prefix QT_PLUGIN_PATH : "${qtbase}/${qtbase.qtPluginPrefix}"
  '';

  meta = {
    maintainers = [ stdenv.lib.maintainers.erictapen ];
    platforms = stdenv.lib.platforms.linux;
    description = "Desktop Publishing (DTP) and Layout program for Linux";
    homepage = http://www.scribus.net;
    license = stdenv.lib.licenses.gpl2;
  };
}
