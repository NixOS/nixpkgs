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
  libXft,
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
  mailcap,
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
  writeText,
  zlib,

  # Boolean flags
  withNativeCompilation ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  noGui ? false,
  srcRepo ? true,
  withAcl ? false,
  withAlsaLib ? false,
  withAthena ? false,
  withCairo ? withX,
  withCsrc ? true,
  withDbus ? stdenv.hostPlatform.isLinux,
  withGTK3 ? withPgtk && !noGui,
  withGlibNetworking ? withPgtk || withGTK3 || (withX && withXwidgets),
  withGpm ? stdenv.hostPlatform.isLinux,
  withImageMagick ? lib.versionOlder version "27" && (withX || withNS),
  # Emacs 30+ has native JSON support
  withJansson ? lib.versionOlder version "30",
  withMailutils ? true,
  withMotif ? false,
  withNS ? stdenv.hostPlatform.isDarwin && !(variant == "macport" || noGui),
  withPgtk ? false,
  withSelinux ? stdenv.hostPlatform.isLinux,
  withSQLite3 ? lib.versionAtLeast version "29",
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  withToolkitScrollBars ? true,
  withTreeSitter ? lib.versionAtLeast version "29",
  withWebP ? lib.versionAtLeast version "29",
  withX ? !(stdenv.hostPlatform.isDarwin || noGui || withPgtk),
  withXinput2 ? withX && lib.versionAtLeast version "29",
  withXwidgets ?
    !stdenv.hostPlatform.isDarwin
    && !noGui
    && (withGTK3 || withPgtk)
    && (lib.versionOlder version "30"), # XXX: upstream bug 66068 precludes newer versions of webkit2gtk (https://lists.gnu.org/archive/html/bug-gnu-emacs/2024-09/msg00695.html)
  withSmallJaDic ? false,
  withCompressInstall ? true,

  # Options
  siteStart ? ./site-start.el,
  toolkit ? (
    if withGTK3 then
      "gtk3"
    else if withMotif then
      "motif"
    else if withAthena then
      "athena"
    else
      "lucid"
  ),

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
}:

assert (withGTK3 && !withNS && variant != "macport") -> withX || withPgtk;

assert noGui -> !(withX || withGTK3 || withNS || variant == "macport");
assert withAcl -> stdenv.hostPlatform.isLinux;
assert withAlsaLib -> stdenv.hostPlatform.isLinux;
assert withGpm -> stdenv.hostPlatform.isLinux;
assert withNS -> stdenv.hostPlatform.isDarwin && !(withX || variant == "macport");
assert withPgtk -> withGTK3 && !withX;
assert withXwidgets -> !noGui && (withGTK3 || withPgtk);

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
      if noGui then
        "-nox"
      else if variant == "macport" then
        "-macport"
      else if withPgtk then
        "-pgtk"
      else if withGTK3 then
        "-gtk3"
      else
        ""
    );
  inherit version;

  inherit src;

  patches =
    patches fetchpatch
    ++ lib.optionals withNativeCompilation [
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
    (lib.optionalString srcRepo ''
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

    ''
      substituteInPlace lisp/net/mailcap.el \
        --replace-fail '"/etc/mime.types"' \
                       '"/etc/mime.types" "${mailcap}/etc/mime.types"' \
        --replace-fail '("/etc/mailcap" system)' \
                       '("/etc/mailcap" system) ("${mailcap}/etc/mailcap" system)'
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
    ++ lib.optionals srcRepo [
      autoreconfHook
      texinfo
    ]
    ++ lib.optionals (withPgtk || withX && (withGTK3 || withXwidgets)) [ wrapGAppsHook3 ];

  buildInputs =
    [
      gettext
      gnutls
      (lib.getDev harfbuzz)
    ]
    ++ lib.optionals withJansson [
      jansson
    ]
    ++ [
      libxml2
      ncurses
    ]
    ++ lib.optionals withAcl [
      acl
    ]
    ++ lib.optionals withAlsaLib [
      alsa-lib
    ]
    ++ lib.optionals withGpm [
      gpm
    ]
    ++ lib.optionals withDbus [
      dbus
    ]
    ++ lib.optionals withSelinux [
      libselinux
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin && withGTK3) [
      gsettings-desktop-schemas
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && withX) [
      libotf
      m17n_lib
    ]
    ++ lib.optionals (withX && withGTK3) [
      gtk3-x11
    ]
    ++ lib.optionals (withX && withMotif) [
      motif
    ]
    ++ lib.optionals withGlibNetworking [
      glib-networking
    ]
    ++ lib.optionals withNativeCompilation [
      libgccjit
      zlib
    ]
    ++ lib.optionals withImageMagick [
      imagemagick
    ]
    ++ lib.optionals withPgtk [
      giflib
      gtk3
      libXpm
      libjpeg
      libpng
      librsvg
      libtiff
    ]
    ++ lib.optionals withSQLite3 [
      sqlite
    ]
    ++ lib.optionals withSystemd [
      systemd
    ]
    ++ lib.optionals withTreeSitter [
      tree-sitter
    ]
    ++ lib.optionals withWebP [
      libwebp
    ]
    ++ lib.optionals withX [
      Xaw3d
      giflib
      libXaw
      libXpm
      libjpeg
      libpng
      librsvg
      libtiff
    ]
    ++ lib.optionals withCairo [
      cairo
    ]
    ++ lib.optionals (withX && !withCairo) [
      libXft
    ]
    ++ lib.optionals withXinput2 [
      libXi
    ]
    ++ lib.optionals withXwidgets [
      webkitgtk_4_0
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      sigtool
    ]
    ++ lib.optionals withNS [
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
  propagatedUserEnvPkgs = lib.optionals withMailutils [
    mailutils
  ];

  hardeningDisable = [ "format" ];

  configureFlags =
    [
      (lib.enableFeature false "build-details") # for a (more) reproducible build
      (lib.withFeature true "modules")
    ]
    ++ (
      if withNS then
        [
          (lib.enableFeature false "ns-self-contained")
        ]
      else if withX then
        [
          (lib.withFeatureAs true "x-toolkit" toolkit)
          (lib.withFeature withCairo "cairo")
          (lib.withFeature (!withCairo) "xft")
        ]
      else if withPgtk then
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
      (lib.withFeature withNS "ns")
    ]
    ++ [
      (lib.withFeature withCompressInstall "compress-install")
      (lib.withFeature withToolkitScrollBars "toolkit-scroll-bars")
      (lib.withFeature withNativeCompilation "native-compilation")
      (lib.withFeature withImageMagick "imagemagick")
      (lib.withFeature withMailutils "mailutils")
      (lib.withFeature withSmallJaDic "small-ja-dic")
      (lib.withFeature withTreeSitter "tree-sitter")
      (lib.withFeature withXinput2 "xinput2")
      (lib.withFeature withXwidgets "xwidgets")
      (lib.withFeature withDbus "dbus")
      (lib.withFeature withSelinux "selinux")
    ];

  env =
    lib.optionalAttrs withNativeCompilation {
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
      cp ${siteStart} $out/share/emacs/site-lisp/site-start.el

      $out/bin/emacs --batch -f batch-byte-compile $out/share/emacs/site-lisp/site-start.el

      siteVersionDir=`ls $out/share/emacs | grep -v site-lisp | head -n 1`

      rm -r $out/share/emacs/$siteVersionDir/site-lisp
    ''
    + lib.optionalString withCsrc ''
      for srcdir in src lisp lwlib ; do
        dstdir=$out/share/emacs/$siteVersionDir/$srcdir
        mkdir -p $dstdir
        find $srcdir -name "*.[chm]" -exec cp {} $dstdir \;
        cp $srcdir/TAGS $dstdir
        echo '((nil . ((tags-file-name . "TAGS"))))' > $dstdir/.dir-locals.el
      done
    ''
    + lib.optionalString withNS ''
      mkdir -p $out/Applications
      mv nextstep/Emacs.app $out/Applications
    ''
    + lib.optionalString (withNativeCompilation && (withNS || variant == "macport")) ''
      ln -snf $out/lib/emacs/*/native-lisp $out/Applications/Emacs.app/Contents/native-lisp
    ''
    + lib.optionalString withNativeCompilation ''
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

  postFixup = lib.optionalString (stdenv.hostPlatform.isLinux && withX && toolkit == "lucid") ''
    patchelf --add-rpath ${lib.makeLibraryPath [ libXcursor ]} $out/bin/emacs
    patchelf --add-needed "libXcursor.so.1" "$out/bin/emacs"
  '';

  setupHook = ./setup-hook.sh;

  passthru = {
    inherit withNativeCompilation;
    inherit withTreeSitter;
    inherit withXwidgets;
    pkgs = recurseIntoAttrs (emacsPackagesFor finalAttrs.finalPackage);
    tests = { inherit (nixosTests) emacs-daemon; };
  };

  meta = meta // {
    broken = withNativeCompilation && !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);
    knownVulnerabilities = lib.optionals (lib.versionOlder version "30") [
      "CVE-2024-53920 CVE-2025-1244, please use newer versions such as emacs30"
    ];
  };
})
