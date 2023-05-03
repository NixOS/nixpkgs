{
  version
  , sha256
  , versionModifier ? ""
  , pname ? "emacs"
  , name ? "emacs-${version}${versionModifier}"
  , patches ? _: [ ]
  , macportVersion ? null
}:
{ stdenv, llvmPackages_6, lib, fetchurl, fetchpatch, substituteAll, ncurses, libXaw, libXpm
, Xaw3d, libXcursor,  pkg-config, gettext, libXft, dbus, libpng, libjpeg, giflib
, libtiff, librsvg, libwebp, gconf, libxml2, imagemagick, gnutls, libselinux
, alsa-lib, cairo, acl, gpm, m17n_lib, libotf
, sigtool, jansson, harfbuzz, sqlite, nixosTests
, recurseIntoAttrs, emacsPackagesFor
, libgccjit, makeWrapper # native-comp params
, fetchFromSavannah, fetchFromBitbucket

  # macOS dependencies for NS and macPort
, AppKit, Carbon, Cocoa, IOKit, OSAKit, Quartz, QuartzCore, WebKit
, ImageCaptureCore, GSS, ImageIO # These may be optional

, withX ? !stdenv.isDarwin && !withPgtk
, withNS ? stdenv.isDarwin && !withMacport
, withMacport ? macportVersion != null
, withGTK2 ? false, gtk2-x11 ? null
, withGTK3 ? withPgtk, gtk3-x11 ? null, gsettings-desktop-schemas ? null
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
, withPgtk ? false, gtk3 ? null
, withXinput2 ? withX && lib.versionAtLeast version "29"
, withImageMagick ? lib.versionOlder version "27" && (withX || withNS)
, toolkit ? (
  if withGTK2 then "gtk2"
  else if withGTK3 then "gtk3"
  else if withMotif then "motif"
  else if withAthena then "athena"
  else "lucid")
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
, withTreeSitter ? lib.versionAtLeast version "29", tree-sitter ? null
}:

assert (libXft != null) -> libpng != null;      # probably a bug
assert stdenv.isDarwin -> libXaw != null;       # fails to link otherwise
assert withNS -> !withX;
assert withNS -> stdenv.isDarwin;
assert withMacport -> !withNS;
assert (withGTK2 && !withNS && !withMacport) -> withX;
assert (withGTK3 && !withNS && !withMacport) -> withX || withPgtk;
assert withGTK2 -> !withGTK3 && gtk2-x11 != null && !withPgtk;
assert withGTK3 -> !withGTK2 && ((gtk3-x11 != null) || withPgtk);
assert withPgtk -> withGTK3 && !withX && gtk3 != null;
assert withXwidgets -> withGTK3 && webkitgtk != null;
assert withTreeSitter -> tree-sitter != null;


let
  libGccJitLibraryPaths = [
    "${lib.getLib libgccjit}/lib/gcc"
    "${lib.getLib stdenv.cc.libc}/lib"
  ] ++ lib.optionals (stdenv.cc?cc.libgcc) [
    "${lib.getLib stdenv.cc.cc.libgcc}/lib"
  ];
in
(if withMacport then llvmPackages_6.stdenv else stdenv).mkDerivation (finalAttrs: (lib.optionalAttrs nativeComp {
  NATIVE_FULL_AOT = "1";
  LIBRARY_PATH = lib.concatStringsSep ":" libGccJitLibraryPaths;
} // {
  pname = pname + lib.optionalString ( !withX && !withNS && !withMacport && !withGTK2 && !withGTK3 ) "-nox";
  inherit version;

  patches = patches fetchpatch ++ lib.optionals nativeComp [
    (substituteAll {
      src = if lib.versionOlder finalAttrs.version "29"
            then ./native-comp-driver-options-28.patch
            else ./native-comp-driver-options.patch;
      backendPath = (lib.concatStringsSep " "
        (builtins.map (x: ''"-B${x}"'') ([
          # Paths necessary so the JIT compiler finds its libraries:
          "${lib.getLib libgccjit}/lib"
        ] ++ libGccJitLibraryPaths ++ [
          # Executable paths necessary for compilation (ld, as):
          "${lib.getBin stdenv.cc.cc}/bin"
          "${lib.getBin stdenv.cc.bintools}/bin"
          "${lib.getBin stdenv.cc.bintools.bintools}/bin"
        ])));
    })
  ];

  src = if macportVersion != null then fetchFromBitbucket {
    owner = "mituharu";
    repo = "emacs-mac";
    rev = macportVersion;
    inherit sha256;
  } else fetchFromSavannah {
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

    ""
  ];

  nativeBuildInputs = [ pkg-config makeWrapper ]
    ++ lib.optionals (srcRepo || withMacport) [ texinfo ]
    ++ lib.optionals srcRepo [ autoreconfHook ]
    ++ lib.optional (withPgtk || withX && (withGTK3 || withXwidgets)) wrapGAppsHook;

  buildInputs =
    [ ncurses gconf libxml2 gnutls gettext jansson harfbuzz.dev ]
    ++ lib.optionals stdenv.isLinux [ dbus libselinux alsa-lib acl gpm ]
    ++ lib.optionals withSystemd [ systemd ]
    ++ lib.optionals withX
      [ libXaw Xaw3d gconf cairo ]
    ++ lib.optionals (withX || withPgtk)
      [ libXpm libpng libjpeg giflib libtiff ]
    ++ lib.optionals (withX || withNS || withPgtk ) [ librsvg ]
    ++ lib.optionals withImageMagick [ imagemagick ]
    ++ lib.optionals (stdenv.isLinux && withX) [ m17n_lib libotf ]
    ++ lib.optional (withX && withGTK2) gtk2-x11
    ++ lib.optional (withX && withGTK3) gtk3-x11
    ++ lib.optional (!stdenv.isDarwin && withGTK3) gsettings-desktop-schemas
    ++ lib.optional withPgtk gtk3
    ++ lib.optional (withX && withMotif) motif
    ++ lib.optional withSQLite3 sqlite
    ++ lib.optional withWebP libwebp
    ++ lib.optionals (withX && withXwidgets) [ webkitgtk glib-networking ]
    ++ lib.optionals withNS [ AppKit GSS ImageIO ]
    ++ lib.optionals withMacport [
      AppKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore WebKit
      # TODO are these optional?
      ImageCaptureCore GSS ImageIO
    ]
    ++ lib.optionals stdenv.isDarwin [ sigtool ]
    ++ lib.optionals nativeComp [ libgccjit ]
    ++ lib.optionals withTreeSitter [ tree-sitter ];

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
    else if withPgtk
      then [ "--with-pgtk" ]
    else [ "--with-x=no" "--with-xpm=no" "--with-jpeg=no" "--with-png=no"
           "--with-gif=no" "--with-tiff=no" ])
    ++ lib.optionals withMacport [
      "--with-mac"
      "--enable-mac-app=$$out/Applications"
      "--with-xml2=yes"
      "--with-gnutls=yes"
    ]
    ++ lib.optional withXwidgets "--with-xwidgets"
    ++ lib.optional nativeComp "--with-native-compilation"
    ++ lib.optional withImageMagick "--with-imagemagick"
    ++ lib.optional withXinput2 "--with-xinput2"
    ++ lib.optional (!withToolkitScrollBars) "--without-toolkit-scroll-bars"
    ++ lib.optional withTreeSitter "--with-tree-sitter"
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
  '' + lib.optionalString (nativeComp && (withNS || withMacport)) ''
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
    treeSitter = withTreeSitter;
    pkgs = recurseIntoAttrs (emacsPackagesFor finalAttrs.finalPackage);
    tests = { inherit (nixosTests) emacs-daemon; };
  };

  meta = with lib; {
    description = "The extensible, customizable GNU text editor" + optionalString withMacport " with Mitsuharu Yamamoto's macport patches";
    homepage    = if withMacport then "https://bitbucket.org/mituharu/emacs-mac/" else "https://www.gnu.org/software/emacs/";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovek323 jwiegley adisbladis matthewbauer atemu ];
    platforms   = if withMacport then platforms.darwin else platforms.all;
    broken      = !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);

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
}))
