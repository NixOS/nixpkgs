{ fetchurl, stdenv, emacs, texinfo, which }:

stdenv.mkDerivation rec {
  name = "org-7.8";

  src = fetchurl {
    url = "http://orgmode.org/${name}.tar.gz";
    sha256 = "0idxsxdr5p0bvnjmhvpdkfwhlpkxmihnaljf43k0311g9z3k22qz";
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

       ensureDir "$out/share/doc/${name}"
       cp -v doc/org*.{html,pdf,txt} "$out/share/doc/${name}"

       ensureDir "$out/share/org"
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

    maintainers = [ stdenv.lib.maintainers.ludo stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
