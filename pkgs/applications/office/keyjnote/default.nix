{ fetchurl, stdenv, python, makeWrapper, lib
, xpdf, pil, pyopengl, pygame
, setuptools, mesa, freeglut }:

let version = "0.10.2";
in
 stdenv.mkDerivation {
    name = "keyjnote-${version}";

    src = fetchurl {
      # XXX: This project has become homeless and Debian seems to be
      # the only reliable way to get its source.
      url = "mirror://debian/pool/main/k/keyjnote/keyjnote_${version}.orig.tar.gz";
      sha256 = "1rnc17da5fkfip2ijzlhxh31rykq5v5bknil8q6xnx30w8ydmy1s";
    };

    # Note: We need to have `setuptools' in the path to be able to use
    # PyOpenGL.
    buildInputs = [ makeWrapper xpdf pil pyopengl pygame ];

    configurePhase = ''
      sed -i "keyjnote.py" \
          -e 's|^#!/usr/bin/env.*$|#!${python}/bin/python|g'
    '';

    installPhase = ''
      ensureDir "$out/bin" "$out/share/doc/keyjnote"
      mv keyjnote.py "$out/bin/keyjnote"
      mv * "$out/share/doc/keyjnote"

      # XXX: We have to reiterate PyOpenGL's dependencies here.
      #
      # `setuptools' must be in the Python path as it's used by
      # PyOpenGL.
      #
      # We set $LIBRARY_PATH (no `LD_'!) so that ctypes can find
      # `libGL.so', which it does by running `gcc', which in turn
      # honors $LIBRARY_PATH.  See
      # http://python.net/crew/theller/ctypes/reference.html#id1 .
      wrapProgram "$out/bin/keyjnote" \
         --prefix PATH ":" "${xpdf}" \
         --prefix PYTHONPATH ":" \
                  ${lib.concatStringsSep ":"
                     (map (path:
                            path + "/lib/python2.5/site-packages:" +
                            path + "/lib/python2.4/site-packages")
                          [ pil pyopengl pygame setuptools ])} \
         --prefix LIBRARY_PATH ":" "${mesa}/lib:${freeglut}/lib"
    '';

    meta = {
      description = "KeyJnote, an effect-rich presentation tool for PDFs";

      # This project has become homeless and will be renamed!
      # See http://keyj.s2000.ws/?p=77 for details.
      #homepage = http://keyjnote.sourceforge.net/;

      license = "GPLv2";
    };
  }
