{ stdenv, lib, fetchurl, ncurses, x11, libXaw, libXpm, Xaw3d
, pkgconfig, gtk, libXft, dbus, libpng, libjpeg, libungif
, libtiff, librsvg, texinfo, gconf, libxml2, imagemagick, gnutls
, alsaLib, cairo, acl, gpm, ghostscript
, withX ? !stdenv.isDarwin
, withGTK3 ? false, gtk3 ? null
, withGTK2 ? true, gtk2
}:

assert (libXft != null) -> libpng != null;	# probably a bug
assert stdenv.isDarwin -> libXaw != null;	# fails to link otherwise
assert withGTK2 -> withX || stdenv.isDarwin;
assert withGTK3 -> withX || stdenv.isDarwin;
assert withGTK2 -> !withGTK3 && gtk2 != null;
assert withGTK3 -> !withGTK2 && gtk3 != null;

let
  toolkit =
    if withGTK3 then "gtk3"
    else if withGTK2 then "gtk2"
    else "lucid";
  addExecPath = lib.filter
    (p: p != null)
    (lib.optionals withX [
      ghostscript
    ]);
  addSiteLisp = lib.optionalString
    (0 < (lib.length addExecPath))
    ''
      ;; Where to find additional programs on NixOS
      (setq exec-path (append exec-path '(
        ${lib.strings.concatMapStringsSep "\n"
          (p: ''"${p}/bin"'') addExecPath})))
    '';
in

stdenv.mkDerivation rec {
  name = "emacs-24.5";

  builder = ./builder.sh;

  src = fetchurl {
    url    = "mirror://gnu/emacs/${name}.tar.xz";
    sha256 = "0kn3rzm91qiswi0cql89kbv6mqn27rwsyjfb8xmwy9m5s8fxfiyx";
  };

  patches = lib.optionals stdenv.isDarwin [
    ./at-fdcwd.patch
  ];

  buildInputs =
    [ ncurses gconf libxml2 gnutls alsaLib pkgconfig texinfo acl gpm ]
    ++ lib.optional stdenv.isLinux dbus
    ++ lib.optionals withX
      [ x11 libXaw Xaw3d libXpm libpng libjpeg libungif libtiff librsvg libXft
        imagemagick gconf ]
    ++ lib.optional (withX && withGTK2) gtk2
    ++ lib.optional (withX && withGTK3) gtk3
    ++ lib.optional (stdenv.isDarwin && withX) cairo;

  configureFlags =
    if withX
      then [ "--with-x-toolkit=${toolkit}" "--with-xft" ]
      else [ "--with-x=no" "--with-xpm=no" "--with-jpeg=no" "--with-png=no"
             "--with-gif=no" "--with-tiff=no" ];

  NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.isDarwin && withX)
    "-I${cairo}/include/cairo";

  inherit addSiteLisp;
  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    echo "$addSiteLisp" | cat ${./site-start.el} - > $out/share/emacs/site-lisp/site-start.el
  '';

  doCheck = true;

  meta = with lib; {
    description = "GNU Emacs 24, the extensible, customizable text editor";
    homepage    = http://www.gnu.org/software/emacs/;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ chaoflow lovek323 simons the-kenny ];
    platforms   = platforms.all;

    # So that Exuberant ctags is preferred
    priority = 1;

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
