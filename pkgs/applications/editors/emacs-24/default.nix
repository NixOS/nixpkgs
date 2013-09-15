{ stdenv, fetchurl, ncurses, x11, libXaw, libXpm, Xaw3d
, pkgconfig, gtk, libXft, dbus, libpng, libjpeg, libungif
, libtiff, librsvg, texinfo, gconf, libxml2, imagemagick, gnutls
, alsaLib, cairo
, withX ? true
}:

assert (libXft != null) -> libpng != null;	# probably a bug
assert stdenv.isDarwin -> libXaw != null;	# fails to link otherwise

stdenv.mkDerivation rec {
  version = "24.3";
  name = "emacs-${version}";

  builder = ./builder.sh;

  src = fetchurl {
    url    = "mirror://gnu/emacs/${name}.tar.xz";
    sha256 = "1385qzs3bsa52s5rcncbrkxlydkw0ajzrvfxgv8rws5fx512kakh";
  };

  buildInputs =
    [ ncurses gconf libxml2 gnutls alsaLib pkgconfig texinfo ]
    ++ stdenv.lib.optional stdenv.isLinux dbus
    ++ stdenv.lib.optionals withX
      [ x11 libXaw Xaw3d libXpm libpng libjpeg libungif libtiff librsvg libXft
        imagemagick gtk ]
    ++ stdenv.lib.optional stdenv.isDarwin cairo;

  configureFlags =
    ( if withX then
        [ "--with-x-toolkit=gtk" "--with-xft"]
      else
        [ "--with-x=no" "--with-xpm=no" "--with-jpeg=no" "--with-png=no"
          "--with-gif=no" "--with-tiff=no" ] )
    # On NixOS, help Emacs find `crt*.o'.
    ++ stdenv.lib.optional (stdenv ? glibc)
         [ "--with-crt-dir=${stdenv.glibc}/lib" ];


  setupHook = ./setup-hook.sh;

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString (stdenv.isDarwin && withX)
    "-I${cairo}/include/cairo";

  doCheck = true;

  # Note: the usual backtick-apostrophe notation for elisp variables
  # and functions in comments is broken in Nix expressions.
  postInstall = ''
    cat >$out/share/emacs/site-lisp/site-start.el <<EOF
;; NixOS specific load-path and package-directory-list
(when (getenv "NIX_PROFILES")
    ;; Add profile directories load-path
    (setq load-path
          (append (reverse (mapcar (lambda (x) (concat x "/share/emacs/site-lisp/"))
                           (split-string (getenv "NIX_PROFILES"))))
                  load-path))
    ;; Add profile directories to package-directory-list for package.el
    (eval-after-load 'package
      '(setq package-directory-list
             (append (mapcar (lambda (x) (concat x "/share/emacs/elpa/"))
                             (split-string (getenv "NIX_PROFILES")))
                     package-directory-list))))

;;; Add package-directories added via Emacs' setupHook to package-directory-list
(eval-after-load 'package
  '(setq package-directory-list
         (append (split-string (or (getenv "EMACS_PACKAGE_EL_PACKAGES") "") ":")
                 package-directory-list)))
EOF
  '';

  meta = with stdenv.lib; {
    description = "GNU Emacs 24, the extensible, customizable text editor";
    homepage    = http://www.gnu.org/software/emacs/;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ chaoflow lovek323 simons the-kenny ];
    platforms   = platforms.all;

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
  };
}
