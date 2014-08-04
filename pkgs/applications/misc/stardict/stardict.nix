{stdenv, fetchurl, pkgconfig, gtk, glib, zlib, libxml2, intltool, gnome_doc_utils, libgnomeui, scrollkeeper, mysql, pcre, which, libxslt}:
stdenv.mkDerivation rec {
  name= "stardict-3.0.3";

  src = fetchurl {
    url = "http://stardict-3.googlecode.com/files/${name}.tar.bz2";
    sha256 = "0wrb8xqy6x9piwrn0vw5alivr9h3b70xlf51qy0jpl6d7mdhm8cv";
  };

  buildInputs = [ pkgconfig gtk glib zlib libxml2 intltool gnome_doc_utils libgnomeui scrollkeeper mysql pcre which libxslt];

  postPatch = ''
    # mysql hacks: we need dynamic linking as there is no libmysqlclient.a
    substituteInPlace tools/configure --replace '/usr/local/include/mysql' '${mysql}/include/mysql/'
    substituteInPlace tools/configure --replace 'AC_FIND_FILE([libmysqlclient.a]' 'AC_FIND_FILE([libmysqlclient.so]'
    substituteInPlace tools/configure --replace '/usr/local/lib/mysql' '${mysql}/lib/mysql/'
    substituteInPlace tools/configure --replace 'for y in libmysqlclient.a' 'for y in libmysqlclient.so'
    substituteInPlace tools/configure --replace 'libmysqlclient.a' 'libmysqlclient.so'

    # a list of p0 patches from gentoo devs
    patch -p0 < ${./stardict-3.0.3-overflow.patch}
    patch -p0 < ${./stardict-3.0.3-gcc46.patch}
    patch -p0 < ${./stardict-3.0.3-compositelookup_cpp.patch}
    patch -p0 < ${./stardict-3.0.3-correct-glib-include.patch}
    patch -p0 < ${./stardict-3.0.3-entry.patch}

    # disable the xsltproc internet query
    substituteInPlace dict/help/Makefile.am --replace 'xsltproc -o' 'xsltproc --nonet -o'
    substituteInPlace dict/help/Makefile.in --replace 'xsltproc -o' 'xsltproc --nonet -o'
  '';

  # another gentoo patch: a p1 patch
  patches = [ ./stardict-3.0.3-zlib-1.2.5.2.patch ];

  configurePhase = ''
    ./configure --disable-spell --disable-gucharmap --disable-festival --disable-espeak --disable-scrollkeeper --prefix=$out
  '';

  meta = {
    description = "stardict";
    homepage = "A international dictionary supporting fuzzy and glob style matching";
    license = stdenv.lib.licenses.lgpl3;
    maintainers = with stdenv.lib.maintainers; [qknight];
  };
}
