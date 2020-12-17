{
  version
  , sha256
  , versionModifier ? ""
  , pname ? "emacs"
  , name ? "emacs-${version}${versionModifier}"
  , patches ? [ ]
}:
{ stdenv, lib, fetchurl, fetchpatch, ncurses, xlibsWrapper, libXaw, libXpm
, Xaw3d, libXcursor,  pkgconfig, gettext, libXft, dbus, libpng, libjpeg, libungif
, libtiff, librsvg, gconf, libxml2, imagemagick, gnutls, libselinux
, alsaLib, cairo, acl, gpm, AppKit, GSS, ImageIO, m17n_lib, libotf
, jansson, harfbuzz
, libgccjit, targetPlatform, makeWrapper # native-comp params
, systemd ? null
, withX ? !stdenv.isDarwin
, withNS ? stdenv.isDarwin
, withGTK2 ? false, gtk2-x11 ? null
, withGTK3 ? true, gtk3-x11 ? null, gsettings-desktop-schemas ? null
, withXwidgets ? false, webkitgtk ? null, wrapGAppsHook ? null, glib-networking ? null
, withCsrc ? true
, srcRepo ? false, autoreconfHook ? null, texinfo ? null
, siteStart ? ./site-start.el
, nativeComp ? false
, withImageMagick ? lib.versionOlder version "27" && (withX || withNS)
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

in stdenv.mkDerivation (lib.optionalAttrs nativeComp {
  NATIVE_FULL_AOT = "1";
  LIBRARY_PATH = "${lib.getLib stdenv.cc.libc}/lib";
} // lib.optionalAttrs stdenv.isDarwin {
  CFLAGS = "-DMAC_OS_X_VERSION_MAX_ALLOWED=101200";
} // {
  inherit pname version patches;

  src = fetchurl {
    url = "mirror://gnu/emacs/${name}.tar.xz";
    inherit sha256;
  };

  enableParallelBuilding = true;

  postPatch = lib.concatStringsSep "\n" [
    (lib.optionalString srcRepo ''
      rm -fr .git
    '')

    ''
    substituteInPlace lisp/international/mule-cmds.el \
      --replace /usr/share/locale ${gettext}/share/locale

    for makefile_in in $(find . -name Makefile.in -print); do
      substituteInPlace $makefile_in --replace /bin/pwd pwd
    done
    ''

    # Make native compilation work both inside and outside of nix build
    (lib.optionalString nativeComp (let
      backendPath = (lib.concatStringsSep " "
        (builtins.map (x: ''\"-B${x}\"'') [
          # Paths necessary so the JIT compiler finds its libraries:
          "${lib.getLib libgccjit}/lib"
          "${lib.getLib libgccjit}/lib/gcc"
          "${lib.getLib stdenv.cc.libc}/lib"

          # Executable paths necessary for compilation (ld, as):
          "${lib.getBin stdenv.cc.cc}/bin"
          "${lib.getBin stdenv.cc.bintools}/bin"
          "${lib.getBin stdenv.cc.bintools.bintools}/bin"
        ]));
    in ''
      substituteInPlace lisp/emacs-lisp/comp.el --replace \
        "(defcustom comp-native-driver-options nil" \
        "(defcustom comp-native-driver-options '(${backendPath})"
    ''))
    ""
  ];

  nativeBuildInputs = [ pkgconfig makeWrapper ]
    ++ lib.optionals srcRepo [ autoreconfHook texinfo ]
    ++ lib.optional (withX && (withGTK3 || withXwidgets)) wrapGAppsHook;

  buildInputs =
    [ ncurses gconf libxml2 gnutls alsaLib acl gpm gettext jansson harfbuzz.dev ]
    ++ lib.optionals stdenv.isLinux [ dbus libselinux systemd ]
    ++ lib.optionals withX
      [ xlibsWrapper libXaw Xaw3d libXpm libpng libjpeg libungif libtiff libXft
        gconf cairo ]
    ++ lib.optionals (withX || withNS) [ librsvg ]
    ++ lib.optionals withImageMagick [ imagemagick ]
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
      then [ "--with-x-toolkit=${toolkit}" "--with-xft" "--with-cairo" ]
      else [ "--with-x=no" "--with-xpm=no" "--with-jpeg=no" "--with-png=no"
             "--with-gif=no" "--with-tiff=no" ])
    ++ lib.optional withXwidgets "--with-xwidgets"
    ++ lib.optional nativeComp "--with-nativecomp"
    ++ lib.optional withImageMagick "--with-imagemagick"
    ;

  installTargets = [ "tags" "install" ];

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    cp ${siteStart} $out/share/emacs/site-lisp/site-start.el

    $out/bin/emacs --batch -f batch-byte-compile $out/share/emacs/site-lisp/site-start.el

    siteVersionDir=`ls $out/share/emacs | grep -v site-lisp | head -n 1`

    rm -r $out/share/emacs/$siteVersionDir/site-lisp
  '' + lib.optionalString withCsrc ''
    for srcdir in src lisp lwlib ; do
      dstdir=$out/share/emacs/$siteVersionDir/$srcdir
      mkdir -p $dstdir
      find $srcdir -name "*.[chm]" -exec cp {} $dstdir \;
      cp $srcdir/TAGS $dstdir
      echo '((nil . ((tags-file-name . "TAGS"))))' > $dstdir/.dir-locals.el
    done
  '' + lib.optionalString withNS ''
    mkdir -p $out/Applications
    mv nextstep/Emacs.app $out/Applications
  '' + lib.optionalString (nativeComp && withNS) ''
    ln -snf $out/lib/emacs/*/native-lisp $out/Applications/Emacs.app/Contents/native-lisp
  '' + lib.optionalString nativeComp ''
    mkdir -p $out/share/emacs/native-lisp
    $out/bin/emacs --batch \
      --eval "(add-to-list 'comp-eln-load-path \"$out/share/emacs/native-lisp\")" \
      -f batch-native-compile $out/share/emacs/site-lisp/site-start.el
  '';

  postFixup = lib.concatStringsSep "\n" [

    (lib.optionalString (stdenv.isLinux && withX && toolkit == "lucid") ''
      patchelf --set-rpath \
        "$(patchelf --print-rpath "$out/bin/emacs"):${lib.makeLibraryPath [ libXcursor ]}" \
        "$out/bin/emacs"
      patchelf --add-needed "libXcursor.so.1" "$out/bin/emacs"
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
})
