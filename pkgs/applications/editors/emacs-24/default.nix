{ stdenv, lib, fetchurl, ncurses, xlibsWrapper, libXaw, libXpm, Xaw3d
, pkgconfig, gettext, libXft, dbus, libpng, libjpeg, libungif
, libtiff, librsvg, texinfo, gconf, libxml2, imagemagick, gnutls
, alsaLib, cairo, acl, gpm, AppKit, CoreWLAN, Kerberos, GSS, ImageIO
, withX ? !stdenv.isDarwin
, withGTK3 ? false, gtk3 ? null
, withGTK2 ? true, gtk2
, enableTTYTrueColor ? false
}:

assert (libXft != null) -> libpng != null;      # probably a bug
assert stdenv.isDarwin -> libXaw != null;       # fails to link otherwise
assert withGTK2 -> withX || stdenv.isDarwin;
assert withGTK3 -> withX || stdenv.isDarwin;
assert withGTK2 -> !withGTK3 && gtk2 != null;
assert withGTK3 -> !withGTK2 && gtk3 != null;

let
  toolkit =
    if withGTK3 then "gtk3"
    else if withGTK2 then "gtk2"
    else "lucid";
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
  ] ++ lib.optionals enableTTYTrueColor [
    # Modified TTY True Color patch from: https://gist.github.com/choppsv1/36aacdd696d505566088
    # To use, pass --color=true-color, which will default to using ';'
    # as the separator.
    # Alternatively, set $EMACS_TRUE_COLOR_SEPARATOR to ';' or ':'.
    ./tty-true-color.patch
  ];

  postPatch = ''
    sed -i 's|/usr/share/locale|${gettext}/share/locale|g' lisp/international/mule-cmds.el
  '';

  buildInputs =
    [ ncurses gconf libxml2 gnutls alsaLib pkgconfig texinfo acl gpm gettext ]
    ++ stdenv.lib.optional stdenv.isLinux dbus
    ++ stdenv.lib.optionals withX
      [ xlibsWrapper libXaw Xaw3d libXpm libpng libjpeg libungif libtiff librsvg libXft
        imagemagick gconf ]
    ++ stdenv.lib.optional (withX && withGTK2) gtk2
    ++ stdenv.lib.optional (withX && withGTK3) gtk3
    ++ stdenv.lib.optional (stdenv.isDarwin && withX) cairo;

  propagatedBuildInputs = stdenv.lib.optionals stdenv.isDarwin [ AppKit GSS ImageIO ];

  configureFlags =
    if stdenv.isDarwin
      then [ "--with-ns" "--disable-ns-self-contained" ]
    else if withX
      then [ "--with-x-toolkit=${toolkit}" "--with-xft" ]
      else [ "--with-x=no" "--with-xpm=no" "--with-jpeg=no" "--with-png=no"
             "--with-gif=no" "--with-tiff=no" ];

  NIX_CFLAGS_COMPILE =
    [ "-ffreestanding" ] # needed due to glibc 2.24 upgrade (see https://sourceware.org/glibc/wiki/Release/2.24#Known_Issues)
    ++ stdenv.lib.optional (stdenv.isDarwin && withX) "-I${cairo.dev}/include/cairo";

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp ${./site-start.el} $out/share/emacs/site-lisp/site-start.el
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv nextstep/Emacs.app $out/Applications
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "GNU Emacs 24, the extensible, customizable text editor";
    homepage    = http://www.gnu.org/software/emacs/;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ chaoflow lovek323 peti the-kenny jwiegley ];
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
