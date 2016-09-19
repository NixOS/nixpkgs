{ stdenv, fetchurl, ncurses, pkgconfig, texinfo, libxml2, gnutls, gettext, autoconf, automake
, AppKit, Carbon, Cocoa, IOKit, OSAKit, Quartz, QuartzCore, WebKit
, ImageCaptureCore, GSS, ImageIO # These may be optional
}:

stdenv.mkDerivation rec {
  emacsName = "emacs-25.1";
  name = "${emacsName}-mac-6.0";

  builder = ./builder.sh;

  src = fetchurl {
    url = "ftp://ftp.gnu.org/gnu/emacs/${emacsName}.tar.xz";
    sha256 = "19f2798ee3bc26c95dca3303e7ab141e7ad65d6ea2b6945eeba4dbea7df48f33";
  };

  macportSrc = fetchurl {
    url = "ftp://ftp.math.s.chiba-u.ac.jp/emacs/${name}.tar.gz";
    sha256 = "2f7a3fd826e6dea541ada04f4a1ff2903a87a1f736b89c5b90bf7bb820568e34";
  };

  enableParallelBuilding = true;

  buildInputs = [ ncurses libxml2 gnutls pkgconfig texinfo gettext autoconf automake];

  propagatedBuildInputs = [
    AppKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore WebKit
    ImageCaptureCore GSS ImageIO   # may be optional
  ];

  postUnpack = ''
    mv $sourceRoot $name
    tar xzf $macportSrc
    mv $name $sourceRoot
  '';

  postPatch = ''
    patch -p1 < patch-mac
    substituteInPlace lisp/international/mule-cmds.el \
      --replace /usr/share/locale ${gettext}/share/locale
  '';

  configureFlags = [
    "LDFLAGS=-L${ncurses.out}/lib"
    "--with-xml2=yes"
    "--with-gnutls=yes"
    "--with-mac"
    "--enable-mac-app=$$out/Applications"
  ];

  CFLAGS = "-O3 -DMAC_OS_X_VERSION_MAX_ALLOWED=1090";
  LDFLAGS = "-O3 -L${ncurses.out}/lib";

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp ${./site-start.el} $out/share/emacs/site-lisp/site-start.el
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "GNU Emacs 25, the extensible, customizable text editor";
    homepage    = http://www.gnu.org/software/emacs/;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ jwiegley ];
    platforms   = platforms.darwin;

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

      This is "Mac port" addition to GNU Emacs 24. This provides a native
      GUI support for Mac OS X 10.4 - 10.11. Note that Emacs 23 and later
      already contain the official GUI support via the NS (Cocoa) port for
      Mac OS X 10.4 and later. So if it is good enough for you, then you
      don't need to try this.
    '';
  };
}
