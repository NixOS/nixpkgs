{ pname
, version
, variant
, src
, patches ? _: [ ]
, meta
}:

{ lib
, stdenv
, Xaw3d
, acl
, alsa-lib
, autoreconfHook
, cairo
, dbus
, emacsPackagesFor
, fetchpatch
, gconf
, gettext
, giflib
, glib-networking
, gnutls
, gpm
, gsettings-desktop-schemas
, gtk2-x11
, gtk3
, gtk3-x11
, harfbuzz
, imagemagick
, jansson
, libXaw
, libXcursor
, libXft
, libXi
, libXpm
, libgccjit
, libjpeg
, libotf
, libpng
, librsvg
, libselinux
, libtiff
, libwebp
, libxml2
, llvmPackages_14
, m17n_lib
, makeWrapper
, motif
, ncurses
, nixosTests
, pkg-config
, recurseIntoAttrs
, sigtool
, sqlite
, substituteAll
, systemd
, tree-sitter
, texinfo
, webkitgtk
, wrapGAppsHook

# Boolean flags
, withNativeCompilation ? stdenv.buildPlatform.canExecute stdenv.hostPlatform
, noGui ? false
, srcRepo ? true
, withAcl ? false
, withAlsaLib ? false
, withAthena ? false
, withCsrc ? true
, withGTK2 ? false
, withGTK3 ? withPgtk && !noGui
, withGconf ? false
, withGlibNetworking ? withPgtk || withGTK3 || (withX && withXwidgets)
, withGpm ? stdenv.isLinux
, withImageMagick ? lib.versionOlder version "27" && (withX || withNS)
, withMotif ? false
, withNS ? stdenv.isDarwin && !(variant == "macport" || noGui)
, withPgtk ? false
, withSQLite3 ? lib.versionAtLeast version "29"
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, withToolkitScrollBars ? true
, withTreeSitter ? lib.versionAtLeast version "29"
, withWebP ? lib.versionAtLeast version "29"
, withX ? !(stdenv.isDarwin || noGui || withPgtk)
, withXinput2 ? withX && lib.versionAtLeast version "29"
, withXwidgets ? !stdenv.isDarwin && !noGui && (withGTK3 || withPgtk)
, withSmallJaDic ? false
, withCompressInstall ? true

# Options
, siteStart ? ./site-start.el
, toolkit ? (
  if withGTK2 then "gtk2"
  else if withGTK3 then "gtk3"
  else if withMotif then "motif"
  else if withAthena then "athena"
  else "lucid")

# macOS dependencies for NS and macPort
, Accelerate
, AppKit
, Carbon
, Cocoa
, GSS
, IOKit
, ImageCaptureCore
, ImageIO
, OSAKit
, Quartz
, QuartzCore
, UniformTypeIdentifiers
, WebKit
}:

assert (withGTK2 && !withNS && variant != "macport") -> withX;
assert (withGTK3 && !withNS && variant != "macport") -> withX || withPgtk;

assert noGui -> !(withX || withGTK2 || withGTK3 || withNS || variant == "macport");
assert withAcl -> stdenv.isLinux;
assert withAlsaLib -> stdenv.isLinux;
assert withGTK2 -> !(withGTK3 || withPgtk);
assert withGTK3 -> !withGTK2 || withPgtk;
assert withGconf -> withX;
assert withGpm -> stdenv.isLinux;
assert withNS -> stdenv.isDarwin && !(withX || variant == "macport");
assert withPgtk -> withGTK3 && !withX;
assert withXwidgets -> !noGui && (withGTK3 || withPgtk);

let
  libGccJitLibraryPaths = [
    "${lib.getLib libgccjit}/lib/gcc"
    "${lib.getLib stdenv.cc.libc}/lib"
  ] ++ lib.optionals (stdenv.cc?cc.libgcc) [
    "${lib.getLib stdenv.cc.cc.libgcc}/lib"
  ];

  inherit (if variant == "macport"
           then llvmPackages_14.stdenv
           else stdenv) mkDerivation;
in
mkDerivation (finalAttrs: {
  pname = pname
          + (if noGui then "-nox"
             else if variant == "macport" then "-macport"
             else if withPgtk then "-pgtk"
             else if withGTK3 then "-gtk3"
             else if withGTK2 then "-gtk2"
             else "");
  inherit version;

  inherit src;

  patches = patches fetchpatch ++ lib.optionals withNativeCompilation [
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

  postPatch = lib.concatStringsSep "\n" [
    (lib.optionalString srcRepo ''
      rm -fr .git
    '')

    # Add the name of the wrapped gvfsd
    # This used to be carried as a patch but it often got out of sync with
    # upstream and was hard to maintain for emacs-overlay.
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

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ] ++ lib.optionals (variant == "macport") [
    texinfo
  ] ++ lib.optionals srcRepo [
    autoreconfHook
    texinfo
  ] ++ lib.optional (withPgtk || withX && (withGTK3 || withXwidgets)) wrapGAppsHook;

  buildInputs = [
    gettext
    gnutls
    harfbuzz.dev
    jansson
    libxml2
    ncurses
  ] ++ lib.optionals withGconf [
    gconf
  ] ++ lib.optionals withAcl [
    acl
  ] ++ lib.optionals withAlsaLib [
    alsa-lib
  ] ++ lib.optionals withGpm [
    gpm
  ] ++ lib.optionals stdenv.isLinux [
    dbus
    libselinux
  ] ++ lib.optionals (!stdenv.isDarwin && withGTK3) [
    gsettings-desktop-schemas
  ] ++ lib.optionals (stdenv.isLinux && withX) [
    libotf
    m17n_lib
  ] ++ lib.optionals (withX && withGTK2) [
    gtk2-x11
  ] ++ lib.optionals (withX && withGTK3) [
    gtk3-x11
  ] ++ lib.optionals (withX && withMotif) [
    motif
  ] ++ lib.optionals withGlibNetworking [
    glib-networking
  ] ++ lib.optionals withNativeCompilation [
    libgccjit
  ] ++ lib.optionals withImageMagick [
    imagemagick
  ] ++ lib.optionals withPgtk [
    giflib
    gtk3
    libXpm
    libjpeg
    libpng
    librsvg
    libtiff
  ] ++ lib.optionals withSQLite3 [
    sqlite
  ] ++ lib.optionals withSystemd [
    systemd
  ] ++ lib.optionals withTreeSitter [
    tree-sitter
  ] ++ lib.optionals withWebP [
    libwebp
  ] ++ lib.optionals withX [
    Xaw3d
    cairo
    giflib
    libXaw
    libXpm
    libjpeg
    libpng
    librsvg
    libtiff
  ] ++ lib.optionals withXinput2 [
    libXi
  ] ++ lib.optionals withXwidgets [
    webkitgtk
  ] ++ lib.optionals stdenv.isDarwin [
    sigtool
  ] ++ lib.optionals withNS [
    librsvg
    AppKit
    GSS
    ImageIO
  ] ++ lib.optionals (variant == "macport") [
    Accelerate
    AppKit
    Carbon
    Cocoa
    IOKit
    OSAKit
    Quartz
    QuartzCore
    UniformTypeIdentifiers
    WebKit
    # TODO are these optional?
    GSS
    ImageCaptureCore
    ImageIO
  ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--disable-build-details" # for a (more) reproducible build
    "--with-modules"
  ] ++ (if withNS then [
    "--disable-ns-self-contained"
  ] else if withX then [
    "--with-x-toolkit=${toolkit}"
    "--with-xft"
    "--with-cairo"
  ] else if withPgtk then [
    "--with-pgtk"
  ] else [
    "--with-gif=no"
    "--with-jpeg=no"
    "--with-png=no"
    "--with-tiff=no"
    "--with-x=no"
    "--with-xpm=no"
  ])
  ++ lib.optionals (variant == "macport") [
    "--enable-mac-app=$$out/Applications"
    "--with-gnutls=yes"
    "--with-mac"
    "--with-xml2=yes"
  ]
  ++ (lib.optional stdenv.isDarwin (lib.withFeature withNS "ns"))
  ++ [
    (lib.withFeature withCompressInstall "compress-install")
    (lib.withFeature withToolkitScrollBars "toolkit-scroll-bars")
    (lib.withFeature withNativeCompilation "native-compilation")
    (lib.withFeature withImageMagick "imagemagick")
    (lib.withFeature withSmallJaDic "small-ja-dic")
    (lib.withFeature withTreeSitter "tree-sitter")
    (lib.withFeature withXinput2 "xinput2")
    (lib.withFeature withXwidgets "xwidgets")
  ];

  env = lib.optionalAttrs withNativeCompilation {
    NATIVE_FULL_AOT = "1";
    LIBRARY_PATH = lib.concatStringsSep ":" libGccJitLibraryPaths;
  } // lib.optionalAttrs (variant == "macport") {
    # Fixes intermittent segfaults when compiled with LLVM >= 7.0.
    # See https://github.com/NixOS/nixpkgs/issues/127902
    NIX_CFLAGS_COMPILE = "-include ${./macport_noescape_noop.h}";
  };

  enableParallelBuilding = true;

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
  '' + lib.optionalString (withNativeCompilation && (withNS || variant == "macport")) ''
    ln -snf $out/lib/emacs/*/native-lisp $out/Applications/Emacs.app/Contents/native-lisp
  '' + lib.optionalString withNativeCompilation ''
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
    inherit withNativeCompilation;
    inherit withTreeSitter;
    pkgs = recurseIntoAttrs (emacsPackagesFor finalAttrs.finalPackage);
    tests = { inherit (nixosTests) emacs-daemon; };
  };

  meta = meta // {
    broken = withNativeCompilation && !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);
  };
})
