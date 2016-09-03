{ stdenv, fetchurl, fetchpatch, pkgconfig, perl, perlXMLParser, gtk, libXft
, libpng, zlib, popt, boehmgc, libxml2, libxslt, glib, gtkmm
, glibmm, libsigcxx, lcms, boost, gettext, makeWrapper, intltool
, gsl, python, numpy, pyxml, lxml, poppler, imagemagick, libwpg, librevenge
, libvisio, libcdr, libexif, unzip, automake114x, autoconf
, boxMakerPlugin ? false # boxmaker plugin
}:

let 

boxmaker = fetchurl {
  # http://www.inkscapeforum.com/viewtopic.php?f=11&t=10403
  url = "http://www.keppel.demon.co.uk/111000/files/BoxMaker0.91.zip";
  sha256 = "5c5697f43dc3a95468f61f479cb50b7e2b93379a1729abf19e4040ac9f43a1a8";
};

stdcxx-patch = fetchpatch {
  url = http://bazaar.launchpad.net/~inkscape.dev/inkscape/trunk/diff/14542?context=3;
  sha256 = "15h831lsh61ichgdygkdkbdm1dlb9mhprldq27hkx2472lcnyx6y";
};

in

stdenv.mkDerivation rec {
  name = "inkscape-0.91";

  src = fetchurl {
    url = "https://inkscape.global.ssl.fastly.net/media/resources/file/"
        + "${name}.tar.bz2";
    sha256 = "06ql3x732x2rlnanv0a8aharsnj91j5kplksg574090rks51z42d";
  };

  patches = [ ./deprecated-scopedptr.patch ];

  postPatch = ''
    patch -i ${stdcxx-patch} -p 0
    patchShebangs share/extensions
  ''
  # Clang gets misdetected, so hardcode the right answer
  + stdenv.lib.optionalString stdenv.cc.isClang ''
    substituteInPlace src/ui/tool/node.h \
      --replace "#if __cplusplus >= 201103L" "#if true"
  '';

  propagatedBuildInputs = [
    # Python is used at run-time to execute scripts, e.g., those from
    # the "Effects" menu.
    python pyxml numpy lxml
  ];

  buildInputs = [
    pkgconfig perl perlXMLParser gtk libXft libpng zlib popt boehmgc
    libxml2 libxslt glib gtkmm glibmm libsigcxx lcms boost gettext
    makeWrapper intltool gsl poppler imagemagick libwpg librevenge
    libvisio libcdr libexif automake114x autoconf
  ] ++ stdenv.lib.optional boxMakerPlugin unzip;

  enableParallelBuilding = true;
  doCheck = true;

  postInstall = ''
    ${if boxMakerPlugin then "
      mkdir -p $out/share/inkscape/extensions/
      # boxmaker packaged version 0.91 in a directory called 0.85 ?!??
      unzip ${boxmaker};
      cp boxmake-upd-0.85/* $out/share/inkscape/extensions/
      rm -Rf boxmake-upd-0.85
      "
    else 
      ""
    }

    # Make sure PyXML modules can be found at run-time.
    for i in "$out/bin/"*
    do
      wrapProgram "$i" --prefix PYTHONPATH :      \
       "$(toPythonPath ${pyxml}):$(toPythonPath ${lxml}):$(toPythonPath ${numpy})"  \
       --prefix PATH : ${python}/bin ||  \
        exit 2
    done
    rm "$out/share/icons/hicolor/icon-theme.cache"
  '';

  meta = with stdenv.lib; {
    license = "GPL";
    homepage = http://www.inkscape.org;
    description = "Vector graphics editor";
    platforms = platforms.all;
    longDescription = ''
      Inkscape is a feature-rich vector graphics editor that edits
      files in the W3C SVG (Scalable Vector Graphics) file format.

      If you want to import .eps files install ps2edit.
    '';
  };
}
