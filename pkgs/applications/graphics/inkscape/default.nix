{ stdenv, fetchurl, pkgconfig, perlPackages, libXft
, libpng, zlib, popt, boehmgc, libxml2, libxslt, glib, gtkmm2
, glibmm, libsigcxx, lcms, boost, gettext, makeWrapper
, gsl, python2, poppler, imagemagick, libwpg, librevenge
, libvisio, libcdr, libexif, potrace, cmake, hicolor-icon-theme
}:

let
  python2Env = python2.withPackages(ps: with ps;
    [ numpy lxml scour ]);
in

stdenv.mkDerivation rec {
  name = "inkscape-0.92.4";

  src = fetchurl {
    url = "https://media.inkscape.org/dl/resources/file/${name}.tar.bz2";
    sha256 = "0pjinhjibfsz1aywdpgpj3k23xrsszpj4a1ya5562dkv2yl2vv2p";
  };

  # Inkscape hits the ARGMAX when linking on macOS. It appears to be
  # CMake’s ARGMAX check doesn’t offer enough padding for NIX_LDFLAGS.
  # Setting strictDeps it avoids duplicating some dependencies so it
  # will leave us under ARGMAX.
  strictDeps = true;

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

  nativeBuildInputs = [ pkgconfig cmake makeWrapper python2Env ]
    ++ (with perlPackages; [ perl XMLParser ]);
  buildInputs = [
    libXft libpng zlib popt boehmgc
    libxml2 libxslt glib gtkmm2 glibmm libsigcxx lcms boost gettext
    gsl poppler imagemagick libwpg librevenge
    libvisio libcdr libexif potrace hicolor-icon-theme

    python2Env perlPackages.perl
  ];

  enableParallelBuilding = true;

  # Make sure PyXML modules can be found at run-time.
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -change $out/lib/libinkscape_base.dylib $out/lib/inkscape/libinkscape_base.dylib $out/bin/inkscape
    install_name_tool -change $out/lib/libinkscape_base.dylib $out/lib/inkscape/libinkscape_base.dylib $out/bin/inkview
  '';

  # 0.92.3 complains about an invalid conversion from const char * to char *
  NIX_CFLAGS_COMPILE = " -fpermissive ";

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
