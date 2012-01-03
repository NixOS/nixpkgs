{ stdenv, fetchurl, ncurses, x11, libXaw, libXpm, Xaw3d
, pkgconfig, gtk, libXft, dbus, libpng, libjpeg, libungif
, libtiff, librsvg, texinfo, gconf
}:

assert (gtk != null) -> (pkgconfig != null);
assert (libXft != null) -> libpng != null;	# probably a bug
assert stdenv.isDarwin -> libXaw != null;	# fails to link otherwise

stdenv.mkDerivation rec {
  name = "emacs-23.3";

  builder = ./builder.sh;

  src = fetchurl {
    url = "mirror://gnu/emacs/${name}.tar.bz2";
    sha256 = "0kfa546qi0idkwk29gclgi13qd8q54pcqgy9qwjknlclszprdp3a";
  };

  buildInputs = 
    [ ncurses x11 texinfo libXaw Xaw3d libXpm libpng libjpeg libungif
      libtiff librsvg libXft gconf
    ] 
    ++ stdenv.lib.optionals (gtk != null) [ gtk pkgconfig ]
    ++ stdenv.lib.optional stdenv.isLinux dbus;

  configureFlags =
    stdenv.lib.optionals (gtk != null) [ "--with-x-toolkit=gtk" "--with-xft"]

    # On NixOS, help Emacs find `crt*.o'.
    ++ stdenv.lib.optional (stdenv ? glibc)
         [ "--with-crt-dir=${stdenv.glibc}/lib" ];

  postInstall = ''
    cat >$out/share/emacs/site-lisp/site-start.el <<EOF
;; nixos specific load-path
(setq load-path
      (append (reverse (mapcar (lambda (x) (concat x "/share/emacs/site-lisp/"))
                               (split-string (getenv "NIX_PROFILES"))))
              load-path))
EOF
  '';

  doCheck = true;

  meta = {
    description = "GNU Emacs 23.x, the extensible, customizable text editor";

    longDescription = ''
      GNU Emacs is an extensible, customizable text editor—and more.  At its
      core is an interpreter for Emacs Lisp, a dialect of the Lisp
      programming language with extensions to support text editing.

      The features of GNU Emacs include: content-sensitive editing modes,
      including syntax coloring, for a wide variety of file types including
      plain text, source code, and HTML; complete built-in documentation,
      including a tutorial for new users; full Unicode support for nearly all
      human languages and their scripts; highly customizable, using Emacs
      Lisp code or a graphical interface; a large number of extensions that
      add other functionality, including a project planner, mail and news
      reader, debugger interface, calendar, and more.  Many of these
      extensions are distributed with GNU Emacs; others are available
      separately.
    '';

    homepage = http://www.gnu.org/software/emacs/;
    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.all;
  };
}
