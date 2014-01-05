{ fetchurl, stdenv, python, makeWrapper, lib
, xpdf, pil, pyopengl, pygame
, setuptools, mesa, freeglut }:

let version = "0.10.3";
in
 stdenv.mkDerivation {
    # This project was formerly known as KeyJNote.
    # See http://keyj.s2000.ws/?p=77 for details.

    name = "impressive-${version}";

    src = fetchurl {
      url = "mirror://sourceforge/impressive/Impressive-${version}.tar.gz";
      sha256 = "0ppr9bckswpi3gav56dhrk91ibxvqbfhpxmm0zikzpxhdlvnaj5v";
    };

    # Note: We need to have `setuptools' in the path to be able to use
    # PyOpenGL.
    buildInputs = [ makeWrapper xpdf pil pyopengl pygame ];

    configurePhase = ''
      sed -i "impressive.py" \
          -e 's|^#!/usr/bin/env.*$|#!${python}/bin/python|g'
    '';

    installPhase = ''
      mkdir -p "$out/bin" "$out/share/doc/impressive"
      mv impressive.py "$out/bin/impressive"
      mv * "$out/share/doc/impressive"

      # XXX: We have to reiterate PyOpenGL's dependencies here.
      #
      # `setuptools' must be in the Python path as it's used by
      # PyOpenGL.
      #
      # We set $LIBRARY_PATH (no `LD_'!) so that ctypes can find
      # `libGL.so', which it does by running `gcc', which in turn
      # honors $LIBRARY_PATH.  See
      # http://python.net/crew/theller/ctypes/reference.html#id1 .
      wrapProgram "$out/bin/impressive" \
         --prefix PATH ":" "${xpdf}" \
         --prefix PYTHONPATH ":" \
                  ${lib.concatStringsSep ":"
                     (map (path:
                            path + "/lib/${python.libPrefix}/site-packages")
                          [ pil pyopengl pygame setuptools ])} \
         --prefix LIBRARY_PATH ":" "${mesa}/lib:${freeglut}/lib"
    '';

    meta = {
      description = "Impressive, an effect-rich presentation tool for PDFs";

      longDescription = ''
        Impressive is a program that displays presentation slides.
        But unlike OpenOffice.org Impress or other similar
        applications, it does so with style.  Smooth alpha-blended
        slide transitions are provided for the sake of eye candy, but
        in addition to this, Impressive offers some unique tools that
        are really useful for presentations.  Read below if you want
        to know more about these features.

        Creating presentations for Impressive is very simple: You just
        need to export a PDF file from your presentation software.
        This means that you can create slides in the application of
        your choice and use Impressive for displaying them.  If your
        application does not support PDF output, you can alternatively
        use a set of pre-rendered image files – or you use Impressive
        to make a slideshow with your favorite photos.
      '';

      homepage = http://impressive.sourceforge.net/;

      license = "GPLv2";

      maintainers = [ stdenv.lib.maintainers.ludo ];
      platforms = stdenv.lib.platforms.mesaPlatforms;
    };
  }
