{ teletextSupport ? true
, jpegSupport ? true
, pngSupport ? true
, recordingSupport ? true
# !!! libXext shouldn't be necessary (it's in x11); but the builder needs it.
, stdenv, fetchurl, pkgconfig, perl, python, x11, libXv, libXmu, libXext, libgnomeui
, libglade, scrollkeeper, esound, gettext, perlXMLParser
, zvbi ? null, libjpeg ? null, libpng ? null, rte ? null }:

assert pkgconfig != null && perl != null && python != null
  && x11 != null && libXv != null && libXmu != null && libgnomeui != null && libglade != null
  && scrollkeeper != null && esound != null && gettext != null
  && perlXMLParser != null;

assert teletextSupport -> zvbi != null && zvbi.pngSupport
  /* !!! && pngSupport && zvbi.libpng == libpng */;

assert jpegSupport -> libjpeg != null;
assert pngSupport -> libpng != null;

assert recordingSupport -> rte != null;

stdenv.mkDerivation {
  name = "zapping-0.7";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/zapping-0.7.tar.bz2;
    md5 = "dd7b3d920509709692c41c9c6c767746";
  };

  inherit teletextSupport jpegSupport pngSupport libXext perlXMLParser;

  buildInputs = [
    pkgconfig perl python x11 libXv libXmu libgnomeui
    libglade scrollkeeper esound gettext
    (if teletextSupport then zvbi else null)
    (if jpegSupport then libjpeg else null)
    (if pngSupport then libpng else null)
    (if recordingSupport then rte else null)
  ];
}
