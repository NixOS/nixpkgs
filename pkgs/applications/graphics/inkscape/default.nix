{ stdenv, fetchurl, fetchpatch, pkgconfig, perl, perlXMLParser, libXft
, libpng, zlib, popt, boehmgc, libxml2, libxslt, glib, gtkmm2
, glibmm, libsigcxx, lcms, boost, gettext, makeWrapper
, gsl, python2, poppler, imagemagick, libwpg, librevenge
, libvisio, libcdr, libexif, potrace, cmake
}:

let
  python2Env = python2.withPackages(ps: with ps; [ numpy lxml ]);
in

stdenv.mkDerivation rec {
  name = "inkscape-0.92.2";

  src = fetchurl {
    url = "https://media.inkscape.org/dl/resources/file/${name}.tar.bz2";
    sha256 = "1lyghk6yarcv9nwkh6k366p6hb7rfilqcvbyji09hki59khd0a56";
  };

  unpackPhase = ''
    cp $src ${name}.tar.bz2
    tar xvjf ${name}.tar.bz2 > /dev/null
    cd ${name}
  '';

  postPatch = ''
    patchShebangs share/extensions
    patchShebangs fix-roff-punct

    # Python is used at run-time to execute scripts, e.g., those from
    # the "Effects" menu.
    substituteInPlace src/extension/implementation/script.cpp \
      --replace '"python-interpreter", "python"' '"python-interpreter", "${python2Env}/bin/python"'
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    perl perlXMLParser libXft libpng zlib popt boehmgc
    libxml2 libxslt glib gtkmm2 glibmm libsigcxx lcms boost gettext
    makeWrapper gsl poppler imagemagick libwpg librevenge
    libvisio libcdr libexif potrace cmake python2Env
  ];

  enableParallelBuilding = true;

  postInstall = ''
    # Make sure PyXML modules can be found at run-time.
    rm "$out/share/icons/hicolor/icon-theme.cache"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -change $out/lib/libinkscape_base.dylib $out/lib/inkscape/libinkscape_base.dylib $out/bin/inkscape
    install_name_tool -change $out/lib/libinkscape_base.dylib $out/lib/inkscape/libinkscape_base.dylib $out/bin/inkview
  '';

  meta = with stdenv.lib; {
    license = "GPL";
    homepage = https://www.inkscape.org;
    description = "Vector graphics editor";
    platforms = platforms.all;
    longDescription = ''
      Inkscape is a feature-rich vector graphics editor that edits
      files in the W3C SVG (Scalable Vector Graphics) file format.

      If you want to import .eps files install ps2edit.
    '';
  };
}
