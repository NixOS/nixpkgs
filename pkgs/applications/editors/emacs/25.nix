{ stdenv, lib, fetchurl, ncurses, xlibsWrapper, libXaw, libXpm, Xaw3d, fetchpatch
, pkgconfig, gettext, libXft, dbus, libpng, libjpeg, libungif
, libtiff, librsvg, gconf, libxml2, imagemagick, gnutls, libselinux
, alsaLib, cairo, acl, gpm, AppKit, GSS, ImageIO
, withX ? !stdenv.isDarwin
, withGTK2 ? false, gtk2 ? null
, withGTK3 ? true, gtk3 ? null, gsettings-desktop-schemas ? null
, withXwidgets ? false, webkitgtk, wrapGAppsHook ? null, glib-networking ? null
, withCsrc ? true
, autoconf ? null, automake ? null, texinfo ? null
}:

assert (libXft != null) -> libpng != null;      # probably a bug
assert stdenv.isDarwin -> libXaw != null;       # fails to link otherwise
assert withGTK2 -> withX || stdenv.isDarwin;
assert withGTK3 -> withX || stdenv.isDarwin;
assert withGTK2 -> !withGTK3 && gtk2 != null;
assert withGTK3 -> !withGTK2 && gtk3 != null;
assert withXwidgets -> withGTK3 && webkitgtk != null;

let
  toolkit =
    if withGTK2 then "gtk2"
    else if withGTK3 then "gtk3"
    else "lucid";
in
stdenv.mkDerivation rec {
  name = "emacs-${version}${versionModifier}";
  version = "25.3";
  versionModifier = "";

  src = fetchurl {
    url = "mirror://gnu/emacs/${name}.tar.xz";
    sha256 = "02y00y9q42g1iqgz5qhmsja75hwxd88yrn9zp14lanay0zkwafi5";
  };

  enableParallelBuilding = true;

  patches = lib.optionals stdenv.isDarwin [
    ./at-fdcwd.patch

    # Backport of the fix to
    # https://lists.gnu.org/archive/html/bug-gnu-emacs/2017-04/msg00201.html
    # Should be removed when switching to Emacs 26.1
    (fetchurl {
      url = "https://gist.githubusercontent.com/aaronjensen/f45894ddf431ecbff78b1bcf533d3e6b/raw/6a5cd7f57341aba673234348d8b0d2e776f86719/Emacs-25-OS-X-use-vfork.patch";
      sha256 = "1nlsxiaynswqhy99jf4mw9x0sndhwcrwy8713kq1l3xqv9dbrzgj";
    })
  ] ++ [
    # Backport patches so we can use webkitgtk with xwidgets.
    (fetchpatch {
      name = "0001-Omit-unnecessary-includes-from-xwidget-c.patch";
      url = "https://github.com/emacs-mirror/emacs/commit/a36ed9b5e95afea5716256bac24d883263aefbaf.patch";
      sha256 = "1j34c0vkj87il87xy1px23yk6bw73adpr7wqa79ncj89i4lc8qkb";
    })
    (fetchpatch {
      name = "0002-xwidget-Use-WebKit2-API.patch";
      url = "https://github.com/emacs-mirror/emacs/commit/d781662873f228b110a128f7a2b6583a4d5e0a3a.patch";
      sha256 = "1lld56zi4cw2hmjxhhdcc0f07k8lbj32h10wcq4ml3asdwa31ryr";
    })
  ];

  nativeBuildInputs = [ pkgconfig autoconf automake texinfo ]
    ++ lib.optional (withX && (withGTK3 || withXwidgets)) wrapGAppsHook;

  buildInputs =
    [ ncurses gconf libxml2 gnutls alsaLib acl gpm gettext ]
    ++ lib.optionals stdenv.isLinux [ dbus libselinux ]
    ++ lib.optionals withX
      [ xlibsWrapper libXaw Xaw3d libXpm libpng libjpeg libungif libtiff librsvg libXft
        imagemagick gconf ]
    ++ lib.optional (withX && withGTK2) gtk2
    ++ lib.optionals (withX && withGTK3) [ gtk3 gsettings-desktop-schemas ]
    ++ lib.optional (stdenv.isDarwin && withX) cairo
    ++ lib.optionals (withX && withXwidgets) [ webkitgtk glib-networking ]
    ++ lib.optionals stdenv.isDarwin [ AppKit GSS ImageIO ];

  hardeningDisable = [ "format" ];

  configureFlags = [ "--with-modules" ] ++
   (if stdenv.isDarwin
      then [ "--with-ns" "--disable-ns-self-contained" ]
    else if withX
      then [ "--with-x-toolkit=${toolkit}" "--with-xft" ]
      else [ "--with-x=no" "--with-xpm=no" "--with-jpeg=no" "--with-png=no"
             "--with-gif=no" "--with-tiff=no" ])
    ++ lib.optional withXwidgets "--with-xwidgets";

  preConfigure = ''
    ./autogen.sh
  '' + ''
    substituteInPlace lisp/international/mule-cmds.el \
      --replace /usr/share/locale ${gettext}/share/locale

    for makefile_in in $(find . -name Makefile.in -print); do
        substituteInPlace $makefile_in --replace /bin/pwd pwd
    done
  '';

  installTargets = [ "tags" "install" ];

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    cp ${./site-start.el} $out/share/emacs/site-lisp/site-start.el
    $out/bin/emacs --batch -f batch-byte-compile $out/share/emacs/site-lisp/site-start.el

    rm -rf $out/var
    rm -rf $out/share/emacs/${version}/site-lisp
  '' + lib.optionalString withCsrc ''
    for srcdir in src lisp lwlib ; do
      dstdir=$out/share/emacs/${version}/$srcdir
      mkdir -p $dstdir
      find $srcdir -name "*.[chm]" -exec cp {} $dstdir \;
      cp $srcdir/TAGS $dstdir
      echo '((nil . ((tags-file-name . "TAGS"))))' > $dstdir/.dir-locals.el
    done
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv nextstep/Emacs.app $out/Applications
  '';

  meta = with stdenv.lib; {
    description = "The extensible, customizable GNU text editor";
    homepage    = https://www.gnu.org/software/emacs/;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovek323 peti the-kenny jwiegley ];
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
