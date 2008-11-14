{ teletextSupport ? true
, jpegSupport ? true
, pngSupport ? true
, recordingSupport ? true
# !!! libXext shouldn't be necessary (it's in x11); but the builder needs it.
, stdenv, fetchurl, pkgconfig, perl, python, x11
, libXv, libXmu, libXext, libgnomeui
, libglade, scrollkeeper, esound, gettext, perlXMLParser
, zvbi ? null, libjpeg ? null, libpng ? null, rte ? null }:

assert teletextSupport -> zvbi != null && zvbi.pngSupport
  /* !!! && pngSupport && zvbi.libpng == libpng */;

assert jpegSupport -> libjpeg != null;
assert pngSupport -> libpng != null;

assert recordingSupport -> rte != null;

stdenv.mkDerivation {
  name = "zapping-0.10cvs6";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nixos.org/tarballs/zapping-0.10cvs6.tar.bz2;
    md5 = "6aa7614ac3fd5d39c89c2198598ad27b";
  };

  inherit teletextSupport jpegSupport pngSupport libXext;

  buildInputs = [
    pkgconfig perl perlXMLParser python x11 libXv libXmu libgnomeui
    libglade scrollkeeper esound gettext
    (if teletextSupport then zvbi else null)
    (if jpegSupport then libjpeg else null)
    (if pngSupport then libpng else null)
    (if recordingSupport then rte else null)
  ];
}
