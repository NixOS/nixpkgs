{ stdenv, fetchurl, fetchpatch, pkgconfig, perlPackages, libXft
, libpng, zlib, popt, boehmgc, libxml2, libxslt, glib, gtkmm2
, glibmm, libsigcxx, lcms, boost, gettext, makeWrapper
, gsl, gtkspell2, cairo, python2, poppler, imagemagick, libwpg, librevenge
, libvisio, libcdr, libexif, potrace, cmake
, librsvg, wrapGAppsHook
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

  patches = [
    (fetchpatch {
      name = "inkscape-poppler_0_76_compat.patch";
      url = "https://gitlab.com/inkscape/inkscape/commit/e831b034746f8dc3c3c1b88372751f6dcb974831.diff";
      sha256 = "096rdyi6ppjq1h9jwwsm9hb99nggfrfinik8rm23jkn4h2zl01zf";
    })
    (fetchpatch {
      name = "inkscape-poppler_0_82_compat.patch";
      url = "https://gitlab.com/inkscape/inkscape/commit/835b6bb62be565efab986d5a3f30a672ad56c7eb.patch";
      sha256 = "02c6sxi2w52b885vr3pgani6kvxp9gdqqk2jgiykkdzv70hhrnm7";
    })
    (fetchpatch {
      name = "inkscape-poppler_0_83_compat.patch";
      url = "https://gitlab.com/inkscape/inkscape/commit/b5360a807b12d4e8318475ffd0464b84882788b5.patch";
      sha256 = "1p44rr2q2i3zkd1y1j7xgdcbgx8yvlq6hq92im8s0bkjby6p5cpz";
    })
  ];

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

  nativeBuildInputs = [ pkgconfig cmake makeWrapper python2Env wrapGAppsHook ]
    ++ (with perlPackages; [ perl XMLParser ]);
  buildInputs = [
    libXft libpng zlib popt boehmgc
    libxml2 libxslt glib gtkmm2 glibmm libsigcxx lcms boost gettext
    gsl poppler imagemagick libwpg librevenge
    libvisio libcdr libexif potrace

    librsvg # for loading icons

    python2Env perlPackages.perl
  ] ++ stdenv.lib.optional (!stdenv.isDarwin) gtkspell2
    ++ stdenv.lib.optional stdenv.isDarwin cairo;

  enableParallelBuilding = true;

  # Make sure PyXML modules can be found at run-time.
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
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
