{ stdenv, lib, fetchurl, fetchpatch, ncurses, xlibsWrapper, libXaw, libXpm
, Xaw3d, libXcursor,  pkgconfig, gettext, libXft, dbus, libpng, libjpeg, libungif
, libtiff, librsvg, gconf, libxml2, imagemagick, gnutls, libselinux
, alsaLib, cairo, acl, gpm, AppKit, GSS, ImageIO, m17n_lib, libotf
, jansson, harfbuzz
, libgccjit, targetPlatform, binutils, binutils-unwrapped, makeWrapper # native-comp params
, systemd ? null
, withX ? !stdenv.isDarwin
, withNS ? stdenv.isDarwin
, withGTK2 ? false, gtk2-x11 ? null
, withGTK3 ? true, gtk3-x11 ? null, gsettings-desktop-schemas ? null
, withXwidgets ? false, webkitgtk ? null, wrapGAppsHook ? null, glib-networking ? null
, withCsrc ? true
, srcRepo ? false, autoconf ? null, automake ? null, texinfo ? null
, siteStart ? ./site-start.el
, nativeComp ? false
, toolkit ? (
  if withGTK2 then "gtk2"
  else if withGTK3 then "gtk3"
  else "lucid")
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
  version = "26.3";
  versionModifier = "";
  name = "emacs-${version}${versionModifier}";

in stdenv.mkDerivation {
  inherit name version;

  src = fetchurl {
    url = "mirror://gnu/emacs/${name}.tar.xz";
    sha256 = "119ldpk7sgn9jlpyngv5y4z3i7bb8q3xp4p0qqi7i5nq39syd42d";
  };

  enableParallelBuilding = true;

  patches = [
    ./clean-env.patch
    ./tramp-detect-wrapped-gvfsd.patch
    # unbreak macOS unexec
    (fetchpatch {
      url = "https://github.com/emacs-mirror/emacs/commit/888ffd960c06d56a409a7ff15b1d930d25c56089.patch";
      sha256 = "08q3ygdigqwky70r47rcgzlkc5jy82xiq8am5kwwy891wlpl7frw";
    })
  ];

  postPatch = lib.concatStringsSep "\n" [
    (lib.optionalString srcRepo ''
      rm -fr .git
    '')

    # Make native compilation work both inside and outside of nix build
    (lib.optionalString nativeComp (let
      libPath = lib.concatStringsSep ":" [
        "${lib.getLib libgccjit}/lib/gcc/${targetPlatform.config}/${libgccjit.version}"
        "${lib.getLib stdenv.cc.cc}/lib"
        "${lib.getLib stdenv.glibc}/lib"
      ];
    in ''
      substituteInPlace lisp/emacs-lisp/comp.el --replace \
        "(defcustom comp-async-env-modifier-form nil" \
        "(defcustom comp-async-env-modifier-form '((setenv \"LIBRARY_PATH\" (string-join (seq-filter (lambda (v) (null (eq v nil))) (list (getenv \"LIBRARY_PATH\") \"${libPath}\")) \":\")))"

    ''))

    ""
  ];

  CFLAGS = "-DMAC_OS_X_VERSION_MAX_ALLOWED=101200";

  LIBRARY_PATH = if nativeComp then "${lib.getLib stdenv.cc.libc}/lib" else "";

  nativeBuildInputs = [ pkgconfig makeWrapper ]
    ++ lib.optionals srcRepo [ autoconf automake texinfo ]
    ++ lib.optional (withX && (withGTK3 || withXwidgets)) wrapGAppsHook;

  buildInputs =
    [ ncurses gconf libxml2 gnutls alsaLib acl gpm gettext jansson harfbuzz.dev ]
    ++ lib.optionals stdenv.isLinux [ dbus libselinux systemd ]
    ++ lib.optionals withX
      [ xlibsWrapper libXaw Xaw3d libXpm libpng libjpeg libungif libtiff libXft
        gconf cairo ]
    ++ lib.optionals (withX || withNS) [ imagemagick librsvg ]
    ++ lib.optionals (stdenv.isLinux && withX) [ m17n_lib libotf ]
    ++ lib.optional (withX && withGTK2) gtk2-x11
    ++ lib.optionals (withX && withGTK3) [ gtk3-x11 gsettings-desktop-schemas ]
    ++ lib.optionals (withX && withXwidgets) [ webkitgtk glib-networking ]
    ++ lib.optionals withNS [ AppKit GSS ImageIO ]
    ++ lib.optionals nativeComp [ libgccjit ]
    ;

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
    ++ lib.optional withXwidgets "--with-xwidgets"
    ++ lib.optional nativeComp "--with-nativecomp"
    ;

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

    siteVersionDir=`ls $out/share/emacs | grep -v site-lisp | head -n 1`

    rm -rf $out/var
    rm -rf $siteVersionDir
  '' + lib.optionalString withCsrc ''
    for srcdir in src lisp lwlib ; do
      dstdir=$siteVersionDir/$srcdir
      mkdir -p $dstdir
      find $srcdir -name "*.[chm]" -exec cp {} $dstdir \;
      cp $srcdir/TAGS $dstdir
      echo '((nil . ((tags-file-name . "TAGS"))))' > $dstdir/.dir-locals.el
    done
  '' + lib.optionalString withNS ''
    mkdir -p $out/Applications
    mv nextstep/Emacs.app $out/Applications
  '';

  postFixup = lib.concatStringsSep "\n" [

    (lib.optionalString (stdenv.isLinux && withX && toolkit == "lucid") ''
      patchelf --set-rpath \
        "$(patchelf --print-rpath "$out/bin/emacs"):${lib.makeLibraryPath [ libXcursor ]}" \
        "$out/bin/emacs"
      patchelf --add-needed "libXcursor.so.1" "$out/bin/emacs"
    '')

    (lib.optionalString nativeComp ''
      wrapProgram $out/bin/emacs-* --prefix PATH : "${lib.makeBinPath [ binutils binutils-unwrapped ]}"
    '')

  ];

  passthru = {
    inherit nativeComp;
  };

  meta = with stdenv.lib; {
    description = "The extensible, customizable GNU text editor";
    homepage    = "https://www.gnu.org/software/emacs/";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovek323 peti jwiegley adisbladis ];
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
