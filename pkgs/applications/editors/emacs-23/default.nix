{ xawSupport ? true
, xpmSupport ? true
, dbusSupport ? true
, xaw3dSupport ? false
, gtkGUI ? false
, xftSupport ? false
, stdenv, fetchurl, ncurses, x11, libXaw ? null, libXpm ? null, Xaw3d ? null
, pkgconfig ? null, gtk ? null, libXft ? null, dbus ? null
, libpng, libjpeg, libungif, libtiff, texinfo
}:

assert xawSupport -> libXaw != null;
assert xpmSupport -> libXpm != null;
assert dbusSupport -> dbus != null;
assert xaw3dSupport -> Xaw3d != null;
assert gtkGUI -> pkgconfig != null && gtk != null;
assert xftSupport -> libXft != null && libpng != null; # libpng = probably a bug
assert stdenv.system == "i686-darwin" -> xawSupport; # fails to link otherwise

stdenv.mkDerivation rec {
  name = "emacs-23.2";

  builder = ./builder.sh;

  src = fetchurl {
    url = "mirror://gnu/emacs/${name}.tar.bz2";
    sha256 = "1i96hp91s86jawrqjhfxm5y2sjxizv99009128b4bh06bgx6dm7z";
  };

  buildInputs = [
    ncurses x11 texinfo
    (if xawSupport then libXaw else null)
    (if xpmSupport then libXpm else null)
    (if dbusSupport then dbus else null)
    (if xaw3dSupport then Xaw3d else null)
    libpng libjpeg libungif libtiff # maybe not strictly required?
  ]
  ++ (if gtkGUI then [pkgconfig gtk] else [])
  ++ (if xftSupport then [libXft] else []);

  configureFlags = "
    ${if gtkGUI then "--with-x-toolkit=gtk --enable-font-backend --with-xft" else ""}
  ";

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

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.linux;  # GTK & co. are needed.
  };
}
