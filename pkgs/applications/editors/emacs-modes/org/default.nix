{ fetchurl, stdenv, emacs, texinfo, which }:

stdenv.mkDerivation rec {
  name = "org-7.8.03";

  src = fetchurl {
    url = "http://orgmode.org/${name}.tar.gz";
    sha256 = "49357cca7d892e70cd2dfcc0b5d96d9fd164ef5a1f251ace3865ecb27dc1e958";
  };

  buildInputs = [ emacs texinfo ];

  patchPhase =
    '' sed -i "lisp/org-clock.el" -e's|"which"|"${which}/bin/which"|g'
    '';

  configurePhase =
    '' sed -i Makefile \
           -e "s|^prefix=.*$|prefix=$out|g"
    '';

  #XXX: fails because of missing UTILITIES/manfull.pl, currently not
  # included in the release tarball, but git.

  #postBuild =
  #  '' make doc
  #  '';

  installPhase =
    '' make install install-info

       mkdir -p "$out/share/doc/${name}"
       cp -v doc/org*.{html,pdf,txt} "$out/share/doc/${name}"

       mkdir -p "$out/share/org"
       cp -R contrib "$out/share/org/contrib"
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

    maintainers = with stdenv.lib.maintainers; [ ludo chaoflow ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
