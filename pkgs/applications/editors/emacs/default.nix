{ stdenv, lib, fetchurl, ncurses, xlibsWrapper, libXaw, libXpm
, Xaw3d, libXcursor,  pkgconfig, gettext, libXft, dbus, libpng, libjpeg, libungif
, libtiff, librsvg, gconf, libxml2, imagemagick, gnutls, libselinux
, alsaLib, cairo, acl, gpm, AppKit, GSS, ImageIO, m17n_lib, libotf
, systemd ? null
, withX ? !stdenv.isDarwin
, withNS ? stdenv.isDarwin
, withGTK2 ? false, gtk2-x11 ? null
, withGTK3 ? true, gtk3-x11 ? null, gsettings-desktop-schemas ? null
, withXwidgets ? false, webkitgtk ? null, wrapGAppsHook ? null, glib-networking ? null
, withCsrc ? true
, srcRepo ? false, autoconf ? null, automake ? null, texinfo ? null
, siteStart ? ./site-start.el
}:

assert (libXft != null) -> libpng != null;      # probably a bug
assert stdenv.isDarwin -> libXaw != null;       # fails to link otherwise
assert withNS -> !withX;
assert withNS -> stdenv.isDarwin;
assert (withGTK2 && !withNS) -> withX;
assert (withGTK3 && !withNS) -> withX;
assert withGTK2 -> !withGTK3 && gtk2-x11 != null;
assert withGTK3 -> !withGTK2 && gtk3-x11 != null;
assert withXwidgets -> withGTK3 && webkitgtk != null;

let
  toolkit =
    if withGTK2 then "gtk2"
    else if withGTK3 then "gtk3"
    else "lucid";
in
stdenv.mkDerivation rec {
  name = "emacs-${version}${versionModifier}";
  version = "26.3";
  versionModifier = "";

  src = fetchurl {
    url = "mirror://gnu/emacs/${name}.tar.xz";
    sha256 = "119ldpk7sgn9jlpyngv5y4z3i7bb8q3xp4p0qqi7i5nq39syd42d";
  };

  enableParallelBuilding = true;

  patches = [
    ./clean-env.patch
    ./tramp-detect-wrapped-gvfsd.patch
  ];

  postPatch = lib.optionalString srcRepo ''
    rm -fr .git
  '';

  CFLAGS = "-DMAC_OS_X_VERSION_MAX_ALLOWED=101200";

  nativeBuildInputs = [ pkgconfig ]
    ++ lib.optionals srcRepo [ autoconf automake texinfo ]
    ++ lib.optional (withX && (withGTK3 || withXwidgets)) wrapGAppsHook;

  buildInputs =
    [ ncurses gconf libxml2 gnutls alsaLib acl gpm gettext ]
    ++ lib.optionals stdenv.isLinux [ dbus libselinux systemd ]
    ++ lib.optionals withX
      [ xlibsWrapper libXaw Xaw3d libXpm libpng libjpeg libungif libtiff libXft
        gconf ]
    ++ lib.optionals (withX || withNS) [ imagemagick librsvg ]
    ++ lib.optionals (stdenv.isLinux && withX) [ m17n_lib libotf ]
    ++ lib.optional (withX && withGTK2) gtk2-x11
    ++ lib.optionals (withX && withGTK3) [ gtk3-x11 gsettings-desktop-schemas ]
    ++ lib.optional (stdenv.isDarwin && withX) cairo
    ++ lib.optionals (withX && withXwidgets) [ webkitgtk glib-networking ]
    ++ lib.optionals withNS [ AppKit GSS ImageIO ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--disable-build-details" # for a (more) reproducible build
    "--with-modules"
  ] ++
    (lib.optional stdenv.isDarwin
      (lib.withFeature withNS "ns")) ++
    (if withNS
      then [ "--disable-ns-self-contained" ]
    else if withX
      then [ "--with-x-toolkit=${toolkit}" "--with-xft" ]
      else [ "--with-x=no" "--with-xpm=no" "--with-jpeg=no" "--with-png=no"
             "--with-gif=no" "--with-tiff=no" ])
    ++ lib.optional withXwidgets "--with-xwidgets";

  preConfigure = lib.optionalString srcRepo ''
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
    cp ${siteStart} $out/share/emacs/site-lisp/site-start.el
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
  '' + lib.optionalString withNS ''
    mkdir -p $out/Applications
    mv nextstep/Emacs.app $out/Applications
  '';

  postFixup =
    let libPath = lib.makeLibraryPath [
      libXcursor
    ];
    in lib.optionalString (stdenv.isLinux && withX && toolkit == "lucid") ''
      patchelf --set-rpath \
        "$(patchelf --print-rpath "$out/bin/emacs"):${libPath}" \
        "$out/bin/emacs"
      patchelf --add-needed "libXcursor.so.1" "$out/bin/emacs"
    '';

  meta = with stdenv.lib; {
    description = "The extensible, customizable GNU text editor";
    homepage    = https://www.gnu.org/software/emacs/;
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovek323 peti the-kenny jwiegley adisbladis ];
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
