{
  version
  , sha256
  , versionModifier ? ""
  , pname ? "emacs"
  , name ? "emacs-${version}${versionModifier}"
  , patches ? [ ]
}:
{ stdenv, lib, fetchurl, fetchpatch, ncurses, xlibsWrapper, libXaw, libXpm
, Xaw3d, libXcursor,  pkg-config, gettext, libXft, dbus, libpng, libjpeg, giflib
, libtiff, librsvg, libwebp, gconf, libxml2, imagemagick, gnutls, libselinux
, alsa-lib, cairo, acl, gpm, AppKit, GSS, ImageIO, m17n_lib, libotf
, sigtool, jansson, harfbuzz, sqlite, nixosTests
, dontRecurseIntoAttrs, emacsPackagesFor
, libgccjit, targetPlatform, makeWrapper # native-comp params
, fetchFromSavannah
, systemd ? null
, withX ? !stdenv.isDarwin
, withNS ? stdenv.isDarwin
, withGTK2 ? false, gtk2-x11 ? null
, withGTK3 ? true, gtk3-x11 ? null, gsettings-desktop-schemas ? null
, withXwidgets ? false, webkitgtk ? null, wrapGAppsHook ? null, glib-networking ? null
, withMotif ? false, motif ? null
, withSQLite3 ? false
, withCsrc ? true
, withWebP ? false
, srcRepo ? true, autoreconfHook ? null, texinfo ? null
, siteStart ? ./site-start.el
, nativeComp ? true
, withAthena ? false
, withToolkitScrollBars ? true
, withPgtk ? false
, withXinput2 ? false
, withImageMagick ? lib.versionOlder version "27" && (withX || withNS)
, toolkit ? (
  if withGTK2 then "gtk2"
  else if withGTK3 then "gtk3"
  else if withMotif then "motif"
  else if withAthena then "athena"
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


let emacs = stdenv.mkDerivation (lib.optionalAttrs nativeComp {
  NATIVE_FULL_AOT = "1";
  LIBRARY_PATH = "${lib.getLib stdenv.cc.libc}/lib";
} // {
  pname = pname + lib.optionalString ( !withX && !withNS && !withGTK2 && !withGTK3 ) "-nox";
  inherit version;

  patches = patches fetchpatch;

  src = fetchFromSavannah {
    repo = "emacs";
    rev = version;
    inherit sha256;
  };

  enableParallelBuilding = true;

  postPatch = lib.concatStringsSep "\n" [
    (lib.optionalString srcRepo ''
      rm -fr .git
    '')

    # Add the name of the wrapped gvfsd
    # This used to be carried as a patch but it often got out of sync with upstream
    # and was hard to maintain for emacs-overlay.
    (lib.concatStrings (map (fn: ''
      sed -i 's#(${fn} "gvfs-fuse-daemon")#(${fn} "gvfs-fuse-daemon") (${fn} ".gvfsd-fuse-wrapped")#' lisp/net/tramp-gvfs.el
    '') [
      "tramp-compat-process-running-p"
      "tramp-process-running-p"
    ]))

    # Reduce closure size by cleaning the environment of the emacs dumper
    ''
      substituteInPlace src/Makefile.in \
        --replace 'RUN_TEMACS = ./temacs' 'RUN_TEMACS = env -i ./temacs'
    ''

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
        "(defcustom native-comp-driver-options nil" \
        "(defcustom native-comp-driver-options '(${backendPath})"
    ''))
    ""
  ];

  nativeBuildInputs = [ pkg-config makeWrapper ]
    ++ lib.optionals srcRepo [ autoreconfHook texinfo ]
    ++ lib.optional (withX && (withGTK3 || withXwidgets)) wrapGAppsHook;

  buildInputs =
    [ ncurses gconf libxml2 gnutls alsa-lib acl gpm gettext jansson harfbuzz.dev ]
    ++ lib.optionals stdenv.isLinux [ dbus libselinux systemd ]
    ++ lib.optionals withX
      [ xlibsWrapper libXaw Xaw3d libXpm libpng libjpeg giflib libtiff libXft
        gconf cairo ]
    ++ lib.optionals (withX || withNS) [ librsvg ]
    ++ lib.optionals withImageMagick [ imagemagick ]
    ++ lib.optionals (stdenv.isLinux && withX) [ m17n_lib libotf ]
    ++ lib.optional (withX && withGTK2) gtk2-x11
    ++ lib.optionals (withX && withGTK3) [ gtk3-x11 gsettings-desktop-schemas ]
    ++ lib.optional (withX && withMotif) motif
    ++ lib.optional withSQLite3 sqlite
    ++ lib.optional withWebP libwebp
    ++ lib.optionals (withX && withXwidgets) [ webkitgtk glib-networking ]
    ++ lib.optionals withNS [ AppKit GSS ImageIO ]
    ++ lib.optionals stdenv.isDarwin [ sigtool ]
    ++ lib.optionals nativeComp [ libgccjit ];

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
    ++ lib.optional nativeComp "--with-native-compilation"
    ++ lib.optional withImageMagick "--with-imagemagick"
    ++ lib.optional withPgtk "--with-pgtk"
    ++ lib.optional withXinput2 "--with-xinput2"
    ++ lib.optional (!withToolkitScrollBars) "--without-toolkit-scroll-bars"
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
    echo "Generating native-compiled trampolines..."
    # precompile trampolines in parallel, but avoid spawning one process per trampoline.
    # 1000 is a rough lower bound on the number of trampolines compiled.
    $out/bin/emacs --batch --eval "(mapatoms (lambda (s) \
      (when (subr-primitive-p (symbol-function s)) (print s))))" \
      | xargs -n $((1000/NIX_BUILD_CORES + 1)) -P $NIX_BUILD_CORES \
        $out/bin/emacs --batch -l comp --eval "(while argv \
          (comp-trampoline-compile (intern (pop argv))))"
    mkdir -p $out/share/emacs/native-lisp
    $out/bin/emacs --batch \
      --eval "(add-to-list 'native-comp-eln-load-path \"$out/share/emacs/native-lisp\")" \
      -f batch-native-compile $out/share/emacs/site-lisp/site-start.el
  '';

  postFixup = lib.optionalString (stdenv.isLinux && withX && toolkit == "lucid") ''
      patchelf --add-rpath ${lib.makeLibraryPath [ libXcursor ]} $out/bin/emacs
      patchelf --add-needed "libXcursor.so.1" "$out/bin/emacs"
  '';

  passthru = {
    inherit nativeComp;
    pkgs = dontRecurseIntoAttrs (emacsPackagesFor emacs);
    tests = { inherit (nixosTests) emacs-daemon; };
  };

  meta = with lib; {
    description = "The extensible, customizable GNU text editor";
    homepage    = "https://www.gnu.org/software/emacs/";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovek323 jwiegley adisbladis ];
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
});
in emacs
