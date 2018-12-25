{ stdenv, fetchsvn, makeWrapper, pkgconfig, cmake, qtbase, cairo, pixman,
boost, cups, fontconfig, freetype, hunspell, libjpeg, libtiff, libxml2, lcms2,
podofo, poppler, poppler_data, python2, harfbuzz, qtimageformats, qttools }:

let
  pythonEnv = python2.withPackages(ps: [ps.tkinter ps.pillow]);
  revision = "22730";
in 
stdenv.mkDerivation rec {
  name = "scribus-unstable-${version}";
  version = "2018-10-13";

  src = fetchsvn {
    url = "svn://scribus.net/trunk/Scribus";
    rev = revision;
    sha256 = "1nlg4qva0fach8fi07r1pakjjlijishpwzlgpnxyaz7r31yjaw63";
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
