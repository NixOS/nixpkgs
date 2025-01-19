{
  pname,
  version,
  variant,
  src,
  patches ? _: [ ],
  meta,
}:

{
  lib,
  stdenv,
  Xaw3d,
  acl,
  alsa-lib,
  apple-sdk,
  autoreconfHook,
  cairo,
  dbus,
  emacsPackagesFor,
  fetchpatch,
  gettext,
  giflib,
  glib-networking,
  gnutls,
  gpm,
  gsettings-desktop-schemas,
  gtk3,
  gtk3-x11,
  harfbuzz,
  imagemagick,
  jansson,
  libXaw,
  libXcursor,
  libXi,
  libXpm,
  libgccjit,
  libjpeg,
  libotf,
  libpng,
  librsvg,
  libselinux,
  libtiff,
  libwebp,
  libxml2,
  llvmPackages_14,
  m17n_lib,
  mailutils,
  makeWrapper,
  motif,
  ncurses,
  nixosTests,
  pkg-config,
  recurseIntoAttrs,
  sigtool,
  sqlite,
  replaceVars,
  systemd,
  tree-sitter,
  texinfo,
  webkitgtk_4_0,
  wrapGAppsHook3,
  zlib,

  # FIXME better dummy values
  # Boolean flags
  withNativeCompilation ? throw "dummy value for backward compatibility, should never be evaled",
  noGui ? throw "dummy value for backward compatibility, should never be evaled",
  srcRepo ? throw "dummy value for backward compatibility, should never be evaled",
  withAcl ? throw "dummy value for backward compatibility, should never be evaled",
  withAlsaLib ? throw "dummy value for backward compatibility, should never be evaled",
  withAthena ? throw "dummy value for backward compatibility, should never be evaled",
  withCsrc ? throw "dummy value for backward compatibility, should never be evaled",
  withDbus ? throw "dummy value for backward compatibility, should never be evaled",
  withGTK3 ? throw "dummy value for backward compatibility, should never be evaled",
  withGlibNetworking ? throw "dummy value for backward compatibility, should never be evaled",
  withGpm ? throw "dummy value for backward compatibility, should never be evaled",
  withImageMagick ? throw "dummy value for backward compatibility, should never be evaled",
  # Emacs 30+ has native JSON support
  withJansson ? throw "dummy value for backward compatibility, should never be evaled",
  withMailutils ? throw "dummy value for backward compatibility, should never be evaled",
  withMotif ? throw "dummy value for backward compatibility, should never be evaled",
  withNS ? throw "dummy value for backward compatibility, should never be evaled",
  withPgtk ? throw "dummy value for backward compatibility, should never be evaled",
  withSelinux ? throw "dummy value for backward compatibility, should never be evaled",
  withSQLite3 ? throw "dummy value for backward compatibility, should never be evaled",
  withSystemd ? throw "dummy value for backward compatibility, should never be evaled",
  withToolkitScrollBars ? throw "dummy value for backward compatibility, should never be evaled",
  withTreeSitter ? throw "dummy value for backward compatibility, should never be evaled",
  withWebP ? throw "dummy value for backward compatibility, should never be evaled",
  withX ? throw "dummy value for backward compatibility, should never be evaled",
  withXinput2 ? throw "dummy value for backward compatibility, should never be evaled",
  withXwidgets ? throw "dummy value for backward compatibility, should never be evaled",
  withSmallJaDic ? throw "dummy value for backward compatibility, should never be evaled",
  withCompressInstall ? throw "dummy value for backward compatibility, should never be evaled",

  # Options
  siteStart ? throw "dummy value for backward compatibility, should never be evaled",
  toolkit ? throw "dummy value for backward compatibility, should never be evaled",

  # macOS dependencies for NS and macPort
  Accelerate,
  AppKit,
  Carbon,
  Cocoa,
  GSS,
  IOKit,
  ImageCaptureCore,
  ImageIO,
  OSAKit,
  Quartz,
  QuartzCore,
  UniformTypeIdentifiers,
  WebKit,
}@args:

let
  libGccJitLibraryPaths =
    [
      "${lib.getLib libgccjit}/lib/gcc"
      "${lib.getLib stdenv.cc.libc}/lib"
    ]
    ++ lib.optionals (stdenv.cc ? cc.lib.libgcc) [
      "${lib.getLib stdenv.cc.cc.lib.libgcc}/lib"
    ];

  inherit (if variant == "macport" then llvmPackages_14.stdenv else stdenv)
    mkDerivation
    ;
in
mkDerivation (finalAttrs: {
  pname =
    pname
    + (
      if finalAttrs.noGui then
        "-nox"
      else if variant == "macport" then
        "-macport"
      else if finalAttrs.withPgtk then
        "-pgtk"
      else if finalAttrs.withGTK3 then
        "-gtk3"
      else
        ""
    );
  inherit version;

  inherit src;

  patches =
    patches fetchpatch
    ++ lib.optionals finalAttrs.withNativeCompilation [
      (replaceVars
        (
          if lib.versionOlder finalAttrs.version "29" then
            ./native-comp-driver-options-28.patch
          else if lib.versionOlder finalAttrs.version "30" then
            ./native-comp-driver-options.patch
          else
            ./native-comp-driver-options-30.patch
        )
        {

          backendPath = (
            lib.concatStringsSep " " (
              builtins.map (x: ''"-B${x}"'') (
                [
                  # Paths necessary so the JIT compiler finds its libraries:
                  "${lib.getLib libgccjit}/lib"
                ]
                ++ libGccJitLibraryPaths
                ++ [
                  # Executable paths necessary for compilation (ld, as):
                  "${lib.getBin stdenv.cc.cc}/bin"
                  "${lib.getBin stdenv.cc.bintools}/bin"
                  "${lib.getBin stdenv.cc.bintools.bintools}/bin"
                ]
                ++ lib.optionals stdenv.hostPlatform.isDarwin [
                  # The linker needs to know where to find libSystem on Darwin.
                  "${apple-sdk.sdkroot}/usr/lib"
                ]
              )
            )
          );
        }
      )
    ];

  postPatch = lib.concatStringsSep "\n" [
    (lib.optionalString finalAttrs.srcRepo ''
      rm -fr .git
    '')

    # Add the name of the wrapped gvfsd
    # This used to be carried as a patch but it often got out of sync with
    # upstream and was hard to maintain for emacs-overlay.
    (lib.concatStrings (
      map
        (fn: ''
          sed -i 's#(${fn} "gvfs-fuse-daemon")#(${fn} "gvfs-fuse-daemon") (${fn} ".gvfsd-fuse-wrapped")#' lisp/net/tramp-gvfs.el
        '')
        [
          "tramp-compat-process-running-p"
          "tramp-process-running-p"
        ]
    ))

    # Reduce closure size by cleaning the environment of the emacs dumper
    ''
      substituteInPlace src/Makefile.in \
        --replace-warn 'RUN_TEMACS = ./temacs' 'RUN_TEMACS = env -i ./temacs'
    ''

    ''
      substituteInPlace lisp/international/mule-cmds.el \
        --replace-warn /usr/share/locale ${gettext}/share/locale

      for makefile_in in $(find . -name Makefile.in -print); do
        substituteInPlace $makefile_in --replace-warn /bin/pwd pwd
      done
    ''

    ""
  ];

  nativeBuildInputs =
    [
      makeWrapper
      pkg-config
    ]
    ++ lib.optionals (variant == "macport") [
      texinfo
    ]
    ++ lib.optionals finalAttrs.srcRepo [
      autoreconfHook
      texinfo
    ]
    ++ lib.optionals (
      finalAttrs.withPgtk || finalAttrs.withX && (finalAttrs.withGTK3 || finalAttrs.withXwidgets)
    ) [ wrapGAppsHook3 ];

  buildInputs =
    [
      gettext
      gnutls
      (lib.getDev harfbuzz)
    ]
    ++ lib.optionals finalAttrs.withJansson [
      jansson
    ]
    ++ [
      libxml2
      ncurses
    ]
    ++ lib.optionals finalAttrs.withAcl [
      acl
    ]
    ++ lib.optionals finalAttrs.withAlsaLib [
      alsa-lib
    ]
    ++ lib.optionals finalAttrs.withGpm [
      gpm
    ]
    ++ lib.optionals finalAttrs.withDbus [
      dbus
    ]
    ++ lib.optionals finalAttrs.withSelinux [
      libselinux
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin && finalAttrs.withGTK3) [
      gsettings-desktop-schemas
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && finalAttrs.withX) [
      libotf
      m17n_lib
    ]
    ++ lib.optionals (finalAttrs.withX && finalAttrs.withGTK3) [
      gtk3-x11
    ]
    ++ lib.optionals (finalAttrs.withX && finalAttrs.withMotif) [
      motif
    ]
    ++ lib.optionals finalAttrs.withGlibNetworking [
      glib-networking
    ]
    ++ lib.optionals finalAttrs.withNativeCompilation [
      libgccjit
      zlib
    ]
    ++ lib.optionals finalAttrs.withImageMagick [
      imagemagick
    ]
    ++ lib.optionals finalAttrs.withPgtk [
      giflib
      gtk3
      libXpm
      libjpeg
      libpng
      librsvg
      libtiff
    ]
    ++ lib.optionals finalAttrs.withSQLite3 [
      sqlite
    ]
    ++ lib.optionals finalAttrs.withSystemd [
      systemd
    ]
    ++ lib.optionals finalAttrs.withTreeSitter [
      tree-sitter
    ]
    ++ lib.optionals finalAttrs.withWebP [
      libwebp
    ]
    ++ lib.optionals finalAttrs.withX [
      Xaw3d
      cairo
      giflib
      libXaw
      libXpm
      libjpeg
      libpng
      librsvg
      libtiff
    ]
    ++ lib.optionals finalAttrs.withXinput2 [
      libXi
    ]
    ++ lib.optionals finalAttrs.withXwidgets [
      webkitgtk_4_0
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      sigtool
    ]
    ++ lib.optionals finalAttrs.withNS [
      librsvg
      AppKit
      GSS
      ImageIO
    ]
    ++ lib.optionals (variant == "macport") [
      Accelerate
      AppKit
      Carbon
      Cocoa
      IOKit
      OSAKit
      Quartz
      QuartzCore
      WebKit
      # TODO are these optional?
      GSS
      ImageCaptureCore
      ImageIO
    ]
    ++ lib.optionals (variant == "macport" && stdenv.hostPlatform.isAarch64) [
      UniformTypeIdentifiers
    ];

  # Emacs needs to find movemail at run time, see info (emacs) Movemail
  propagatedUserEnvPkgs = lib.optionals finalAttrs.withMailutils [
    mailutils
  ];

  hardeningDisable = [ "format" ];

  configureFlags =
    [
      (lib.enableFeature false "build-details") # for a (more) reproducible build
      (lib.withFeature true "modules")
    ]
    ++ (
      if finalAttrs.withNS then
        [
          (lib.enableFeature false "ns-self-contained")
        ]
      else if finalAttrs.withX then
        [
          (lib.withFeatureAs true "x-toolkit" finalAttrs.toolkit)
          (lib.withFeature true "cairo")
          (lib.withFeature true "xft")
        ]
      else if finalAttrs.withPgtk then
        [
          (lib.withFeature true "pgtk")
        ]
      else
        [
          (lib.withFeature false "gif")
          (lib.withFeature false "jpeg")
          (lib.withFeature false "png")
          (lib.withFeature false "tiff")
          (lib.withFeature false "x")
          (lib.withFeature false "xpm")
        ]
    )
    ++ lib.optionals (variant == "macport") [
      (lib.enableFeatureAs true "mac-app" "$$out/Applications")
      (lib.withFeature true "gnutls")
      (lib.withFeature true "mac")
      (lib.withFeature true "xml2")
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      (lib.withFeature finalAttrs.withNS "ns")
    ]
    ++ [
      (lib.withFeature finalAttrs.withCompressInstall "compress-install")
      (lib.withFeature finalAttrs.withToolkitScrollBars "toolkit-scroll-bars")
      (lib.withFeature finalAttrs.withNativeCompilation "native-compilation")
      (lib.withFeature finalAttrs.withImageMagick "imagemagick")
      (lib.withFeature finalAttrs.withMailutils "mailutils")
      (lib.withFeature finalAttrs.withSmallJaDic "small-ja-dic")
      (lib.withFeature finalAttrs.withTreeSitter "tree-sitter")
      (lib.withFeature finalAttrs.withXinput2 "xinput2")
      (lib.withFeature finalAttrs.withXwidgets "xwidgets")
      (lib.withFeature finalAttrs.withDbus "dbus")
      (lib.withFeature finalAttrs.withSelinux "selinux")
    ];

  env =
    lib.optionalAttrs finalAttrs.withNativeCompilation {
      NATIVE_FULL_AOT = "1";
      LIBRARY_PATH = lib.concatStringsSep ":" libGccJitLibraryPaths;
    }
    // lib.optionalAttrs (variant == "macport") {
      # Fixes intermittent segfaults when compiled with LLVM >= 7.0.
      # See https://github.com/NixOS/nixpkgs/issues/127902
      NIX_CFLAGS_COMPILE = "-include ${./macport_noescape_noop.h}";
    };

  enableParallelBuilding = true;

  installTargets = [
    "tags"
    "install"
  ];

  postInstall =
    ''
      mkdir -p $out/share/emacs/site-lisp
      cp ${finalAttrs.siteStart} $out/share/emacs/site-lisp/site-start.el

      $out/bin/emacs --batch -f batch-byte-compile $out/share/emacs/site-lisp/site-start.el

      siteVersionDir=`ls $out/share/emacs | grep -v site-lisp | head -n 1`

      rm -r $out/share/emacs/$siteVersionDir/site-lisp
    ''
    + lib.optionalString finalAttrs.withCsrc ''
      for srcdir in src lisp lwlib ; do
        dstdir=$out/share/emacs/$siteVersionDir/$srcdir
        mkdir -p $dstdir
        find $srcdir -name "*.[chm]" -exec cp {} $dstdir \;
        cp $srcdir/TAGS $dstdir
        echo '((nil . ((tags-file-name . "TAGS"))))' > $dstdir/.dir-locals.el
      done
    ''
    + lib.optionalString finalAttrs.withNS ''
      mkdir -p $out/Applications
      mv nextstep/Emacs.app $out/Applications
    ''
    +
      lib.optionalString (finalAttrs.withNativeCompilation && (finalAttrs.withNS || variant == "macport"))
        ''
          ln -snf $out/lib/emacs/*/native-lisp $out/Applications/Emacs.app/Contents/native-lisp
        ''
    + lib.optionalString finalAttrs.withNativeCompilation ''
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

  postFixup =
    lib.optionalString
      (stdenv.hostPlatform.isLinux && finalAttrs.withX && finalAttrs.toolkit == "lucid")
      ''
        patchelf --add-rpath ${lib.makeLibraryPath [ libXcursor ]} $out/bin/emacs
        patchelf --add-needed "libXcursor.so.1" "$out/bin/emacs"
      '';

  # these "args.withFoo or" are for backward compatibility (.override)
  withNativeCompilation =
    args.withNativeCompilation or stdenv.buildPlatform.canExecute
      stdenv.hostPlatform;
  noGui = args.noGui or false;
  srcRepo = args.srcRepo or true;
  withAcl = args.withAcl or false;
  withAlsaLib = args.withAlsaLib or false;
  withAthena = args.withAthena or false;
  withCsrc = args.withCsrc or true;
  withDbus = args.withDbus or stdenv.hostPlatform.isLinux;
  withGTK3 = args.withGTK3 or finalAttrs.withPgtk && !finalAttrs.noGui;
  withGlibNetworking =
    args.withGlibNetworking or finalAttrs.withPgtk
    || finalAttrs.withGTK3
    || (finalAttrs.withX && finalAttrs.withXwidgets);
  withGpm = args.withGpm or stdenv.hostPlatform.isLinux;
  withImageMagick =
    args.withImageMagick or lib.versionOlder finalAttrs.version "27"
    && (finalAttrs.withX || finalAttrs.withNS);
  withJansson = args.withJansson or lib.versionOlder finalAttrs.version "30";
  withMailutils = args.withMailutils or true;
  withMotif = args.withMotif or false;
  withNS = args.withNS or stdenv.hostPlatform.isDarwin && !(variant == "macport" || finalAttrs.noGui);
  withPgtk = args.withPgtk or false;
  withSelinux = args.withSelinux or stdenv.hostPlatform.isLinux;
  withSQLite3 = args.withSQLite3 or lib.versionAtLeast finalAttrs.version "29";
  withSystemd = args.withSystemd or lib.meta.availableOn stdenv.hostPlatform systemd;
  withToolkitScrollBars = args.withToolkitScrollBars or true;
  withTreeSitter = args.withTreeSitter or lib.versionAtLeast finalAttrs.version "29";
  withWebP = args.withWebP or lib.versionAtLeast finalAttrs.version "29";
  withX = args.withX or (!(stdenv.hostPlatform.isDarwin || finalAttrs.noGui || finalAttrs.withPgtk));
  withXinput2 = args.withXinput2 or finalAttrs.withX && lib.versionAtLeast finalAttrs.version "29";
  withXwidgets =
    args.withXwidgets or (!stdenv.hostPlatform.isDarwin)
    && !finalAttrs.noGui
    && (finalAttrs.withGTK3 || finalAttrs.withPgtk)
    && (lib.versionOlder finalAttrs.version "30"); # XXX: upstream bug 66068 precludes newer versions of webkit2gtk (https://lists.gnu.org/archive/html/bug-gnu-emacs/2024-09/msg00695.html)
  withSmallJaDic = args.withSmallJaDic or false;
  withCompressInstall = args.withCompressInstall or true;

  siteStart = args.siteStart or ./site-start.el;
  toolkit =
    args.toolkit or (
      if finalAttrs.withGTK3 then
        "gtk3"
      else if finalAttrs.withMotif then
        "motif"
      else if finalAttrs.withAthena then
        "athena"
      else
        "lucid"
    );

  # FIXME handle assertions better
  assertions =
    assert
      (finalAttrs.withGTK3 && !finalAttrs.withNS && variant != "macport")
      -> finalAttrs.withX || finalAttrs.withPgtk;
    assert
      finalAttrs.noGui
      -> !(finalAttrs.withX || finalAttrs.withGTK3 || finalAttrs.withNS || variant == "macport");
    assert finalAttrs.withAcl -> stdenv.hostPlatform.isLinux;
    assert finalAttrs.withAlsaLib -> stdenv.hostPlatform.isLinux;
    assert finalAttrs.withGpm -> stdenv.hostPlatform.isLinux;
    assert
      finalAttrs.withNS -> stdenv.hostPlatform.isDarwin && !(finalAttrs.withX || variant == "macport");
    assert finalAttrs.withPgtk -> finalAttrs.withGTK3 && !finalAttrs.withX;
    assert finalAttrs.withXwidgets -> !finalAttrs.noGui && (finalAttrs.withGTK3 || finalAttrs.withPgtk);
    true; # dummy value to make syntax right

  passthru = {
    pkgs = recurseIntoAttrs (emacsPackagesFor finalAttrs.finalPackage);
    tests = { inherit (nixosTests) emacs-daemon; };
  };

  meta = meta // {
    broken = finalAttrs.withNativeCompilation && !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);
  };
})
