{ fetchurl, stdenv, emacs, texinfo, which }:

stdenv.mkDerivation rec {
  name = "org-7.5";

  src = fetchurl {
    url = "http://orgmode.org/${name}.tar.gz";
    sha256 = "978822bc4c5f9f67450fbaa8572f1d4217406b7e28551278c9f23f7e9515cd4b";
  };

  buildInputs = [ emacs texinfo ];

  patchPhase =
    '' sed -i "lisp/org-clock.el" -e's|"which"|"${which}/bin/which"|g'
    '';

  configurePhase =
    '' sed -i Makefile \
           -e "s|^prefix=.*$|prefix=$out|g"
    '';

  installPhase =
    '' make install install-info

       ensureDir "$out/share/doc/${name}"
       cp -v doc/orgcard*.{pdf,txt} "$out/share/doc/${name}"
    '';

  meta = {
    description = "Org-Mode, an Emacs mode for notes, project planning, and authoring";

    longDescription =
      '' Org-mode is for keeping notes, maintaining ToDo lists, doing project
         planning, and authoring with a fast and effective plain-text system.

         This package contains a version of Org-mode typically more recent
         than that found in GNU Emacs.
      '';

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
