{
  buildPackages,
  lib,
  pkgsBuildBuild,
  pkgsBuildHost,
  pkgsCross,
  pdfium,
  stdenv,
  fetchurl,
  fetchzip,
  freetype,
  gclient2nix,
  glib,
  glibcLocales,
  gn,
  harfbuzz,
  icu,
  lcms2,
  libjpeg,
  libpng,
  libtiff,
  llvmPackages,
  ninja,
  openjpeg,
  symlinkJoin,
  xcodebuild,
  zlib,
}:

let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);

  versionInfo = sources.version;

  version = toString versionInfo.build;
  chromiumSrcRef = "refs/branch-heads/${version}";

  canRunTests = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  canCrossTest =
    stdenv.buildPlatform == stdenv.hostPlatform
    && stdenv.hostPlatform.isLinux
    && stdenv.hostPlatform.isx86_64;

  gclientDeps = gclient2nix.importGclientDeps (
    {
      "src" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://pdfium.googlesource.com/pdfium";
          rev = "refs/heads/chromium/${version}";
          inherit (sources.pdfium) hash;
        };
      };

      "src/build" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/chromium/src/build.git";
          inherit (sources.build) rev hash;
        };
      };

      "src/third_party/abseil-cpp" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/chromium/src/third_party/abseil-cpp";
          inherit (sources.abseil) rev hash;
        };
      };

      "src/third_party/fast_float/src" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/external/github.com/fastfloat/fast_float";
          inherit (sources.fastFloat) rev hash;
        };
      };

      "src/third_party/simdutf" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/chromium/src/third_party/simdutf";
          inherit (sources.simdutf) rev hash;
        };
      };

      "src/third_party/test_fonts" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/chromium/src/third_party/test_fonts";
          inherit (sources.testFonts) rev hash;
        };
      };
    }
    // lib.optionalAttrs canRunTests {
      # PDFium's native test targets use Chromium's googletest wrapper targets.
      "src/third_party/googletest/src" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/external/github.com/google/googletest";
          inherit (sources.gtest) rev hash;
        };
      };
    }
  );

  generateShimHeaders = fetchzip {
    url = "https://chromium.googlesource.com/chromium/src/+archive/${chromiumSrcRef}/tools/generate_shim_headers.tar.gz";
    inherit (sources.generateShimHeaders) hash;
    stripRoot = false;
  };

  chromiumBuildtools = fetchzip {
    url = "https://chromium.googlesource.com/chromium/src/+archive/${chromiumSrcRef}/buildtools.tar.gz";
    inherit (sources.chromiumBuildtools) hash;
    stripRoot = false;
  };

  testFontsBundle = fetchurl {
    url = "https://storage.googleapis.com/chromium-fonts/${sources.testFonts.bundle.object}";
    inherit (sources.testFonts.bundle) hash;
  };

  chromiumCpu =
    platform:
    if platform.isx86_64 then
      "x64"
    else if platform.isAarch64 then
      "arm64"
    else
      throw "unsupported CPU for pdfium";
  chromiumToolchain =
    if stdenv.hostPlatform.isLinux then
      "//build/toolchain/linux/unbundle:default"
    else if stdenv.hostPlatform.isDarwin then
      "//build/toolchain/mac:clang_${chromiumCpu stdenv.hostPlatform}"
    else
      throw "unsupported platform for pdfium";
  chromiumHostToolchain =
    if stdenv.hostPlatform.isLinux && stdenv.buildPlatform != stdenv.hostPlatform then
      "//build/toolchain/linux/unbundle:host"
    else
      chromiumToolchain;
  chromiumOs =
    platform:
    if platform.isLinux then
      "linux"
    else if platform.isDarwin then
      "mac"
    else
      throw "unsupported OS for pdfium";
  buildToolStdenv = buildPackages.stdenv;
  clangMajor = builtins.head (lib.splitVersion (lib.getVersion stdenv.cc.cc));

  chromiumClang = symlinkJoin {
    name = "chromium-clang-${lib.getVersion stdenv.cc.cc}";
    paths = [
      stdenv.cc.cc.libllvm
      stdenv.cc
    ];
  };

  disabledUnitTests = [
    # This checks for one exact compressed byte sequence, but PDFium here
    # intentionally uses the system zlib implementation.
    "FlateModule.Encode"
    # This observes retain/release churn through std::set lookup and differs
    # with the system standard library implementation used in nixpkgs.
    "RetainPtr.SetContains"
  ];

  disabledEmbedderTests = [
    # These assert exact serialized PDF and font-subset output. With system
    # libraries, output differs from upstream's in-tree stack; known
    # contributors are HarfBuzz subsetting and zlib-compressed save output.
    "CPDFFontSubsetterTest.MultipleFontsMultipleTexts"
    "FPDFSaveWithFontSubsetEmbedderTest.SaveWithoutSubsetWithNewText"
    "FPDFSaveWithFontSubsetEmbedderTest.SaveWithSubsetWithNewText"
    # These render tests also differ from upstream's in-tree stack. The known
    # FreeType difference is the system autofit/autohinting configuration.
    "FPDFViewEmbedderTest.RenderAnnotsGrayScale"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "FPDFProgressiveRenderEmbedderTest.RenderHighlightWithColorScheme"
    "FPDFProgressiveRenderEmbedderTest.RenderHighlightWithColorSchemeAndConvertFillToStroke"
    "FPDFAnnotEmbedderTest.ModifyRectQuadpointsWithAP"
  ];

  mkDisabledGtestFilter = disabledTests: "-${lib.concatStringsSep ":" disabledTests}";
  unitTestFilter = mkDisabledGtestFilter disabledUnitTests;
  embedderTestFilter = mkDisabledGtestFilter disabledEmbedderTests;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pdfium";
  inherit version gclientDeps;
  outputs = [
    "out"
    "dev"
  ];

  sourceRoot = "src";
  __structuredAttrs = true;
  strictDeps = true;
  doCheck = canRunTests;

  patches = [
    # Drop Clang flags that older nixpkgs Clang does not support.
    ./clang-pre-23-compat.patch
    # Apply PDFium's floating-point contraction setting to GCC too.
    ./ffp-contract-off-with-gcc.patch
    # Let the wrapped nixpkgs Clang provide its compiler runtime.
    ./use-system-clang-runtime.patch
    # Let the nixpkgs compiler wrapper configure system libc++ hardening.
    ./use-system-libcxx-hardening.patch
    # Keep thin archives linkable when Linux Clang builds use the system linker.
    ./thin-archive-no-lld.patch
    # Fix Chromium's Linux unbundle cross toolchain on nixpkgs.
    ./cross-compile.patch
    # Use the full GNU target triple expected by nixpkgs' cross Clang wrapper.
    ./clang-arm64-target.patch
    # Let Chromium's pkg-config helper run on non-Linux hosts.
    ./pkg-config-non-linux.patch
    # Keep /nix/store paths out of the macOS SDK sysroot rewrite.
    ./pkg-config-absolute-paths.patch
    # Accept the same 1-channel Apple rendering tolerance as PDFium's fuzzy
    # helper for Mac expectation-suffix embedder tests.
    ./darwin-embedder-test-pixel-tolerance.patch
  ];

  nativeBuildInputs = [
    gclient2nix.gclientUnpackHook
    gn
    ninja
    pkgsBuildHost.pkg-config
    buildPackages.python3
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.buildPlatform != stdenv.hostPlatform) [
    # host_pkg_config points at the build-side wrapper, so it must be part of
    # the environment for its setup hook to populate build-side search paths.
    pkgsBuildBuild.pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcodebuild
  ];

  buildInputs = [
    freetype
    glib
    harfbuzz
    icu
    lcms2
    libjpeg
    libpng
    libtiff
    openjpeg
    zlib
  ];

  env = lib.optionalAttrs (stdenv.hostPlatform.isLinux && canRunTests) {
    # Locale-sensitive tests expect glibc locales to be available.
    LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
  };

  postPatch = ''
    substituteInPlace BUILD.gn \
      --replace-fail 'component("pdfium")' 'shared_library("pdfium")'

    substituteInPlace public/fpdfview.h \
      --replace-fail '#if defined(COMPONENT_BUILD)' '#if defined(COMPONENT_BUILD) || defined(FPDF_IMPLEMENTATION)'

    mkdir -p third_party/icu
    cp build/linux/unbundle/icu.gn third_party/icu/BUILD.gn

    install -Dm644 ${generateShimHeaders}/generate_shim_headers.py \
      tools/generate_shim_headers/generate_shim_headers.py

    echo 'build_with_chromium = false' > build/config/gclient_args.gni
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    patchShebangs --build build/toolchain/apple/linker_driver.py
  ''
  + lib.optionalString stdenv.cc.isClang ''
    # Clang builds still load helper targets from Chromium's buildtools tree
    # even when PDFium links against the system libc++.
    mkdir -p buildtools
    cp -r ${chromiumBuildtools}/. buildtools
  ''
  + lib.optionalString canRunTests ''
    tar -xzf ${testFontsBundle} -C third_party/test_fonts
  '';

  preConfigure =
    lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.buildPlatform != stdenv.hostPlatform)
      ''
        # Chromium's unbundle host toolchain reads BUILD_* directly from the
        # environment rather than discovering the wrappers itself.
        export READELF="${lib.getExe' stdenv.cc.bintools "${stdenv.cc.targetPrefix}readelf"}"
        export BUILD_CC="${lib.getExe' buildToolStdenv.cc "cc"}"
        export BUILD_CXX="${lib.getExe' buildToolStdenv.cc "c++"}"
        export BUILD_AR="${lib.getExe' buildToolStdenv.cc.bintools "ar"}"
        export BUILD_NM="${lib.getExe' buildToolStdenv.cc.bintools "nm"}"
        export BUILD_READELF="${lib.getExe' buildToolStdenv.cc.bintools "readelf"}"
      '';

  gnFlags = [
    # Build a release-style shared library rather than GN's default
    # unofficial debug configuration.
    "is_debug=false"

    # Chromium's custom_toolchain is the target/default toolchain. For native
    # Linux, unbundle expects host_toolchain to be the same :default toolchain;
    # only cross builds switch it to :host for build-machine tools.
    "custom_toolchain=\"${chromiumToolchain}\""
    "host_toolchain=\"${chromiumHostToolchain}\""

    # Upstream's PDFium checkout defaults to Chromium sysroots and in-tree
    # libc++, neither of which exists in this minimal nixpkgs build.
    "use_sysroot=false"
    "use_custom_libcxx=false"
    "use_custom_libcxx_for_host=false"

    # Nixpkgs GCC and Clang emit diagnostics that Chromium's own toolchain does
    # not, so do not promote warnings to errors.
    "treat_warnings_as_errors=false"

    # Keep the build lean and avoid pulling V8 or PartitionAlloc into the
    # dependency set.
    "pdf_enable_v8=false"
    "pdf_use_partition_alloc=false"

    # Prefer system libraries when PDFium already supports that mode.
    "pdf_bundle_freetype=false"
    "use_system_freetype=true"
    "use_system_libjpeg=true"
    "use_system_lcms2=true"
    "use_system_libopenjpeg2=true"
    "use_system_libpng=true"
    "use_system_libtiff=true"
    "use_system_zlib=true"
    "use_system_harfbuzz=true"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.buildPlatform != stdenv.hostPlatform) [
    # GN otherwise infers these from the build machine instead of the target.
    "host_cpu=\"${chromiumCpu stdenv.buildPlatform}\""
    "host_os=\"${chromiumOs stdenv.buildPlatform}\""
    "target_cpu=\"${chromiumCpu stdenv.hostPlatform}\""
    "target_os=\"${chromiumOs stdenv.hostPlatform}\""

    # Chromium's pkg-config helper needs explicit build-side and target-side
    # wrappers when cross-compiling with the unbundle toolchain.
    "host_pkg_config=\"${pkgsBuildBuild.pkg-config}/bin/pkg-config\""
    "pkg_config=\"${pkgsBuildHost.pkg-config}/bin/${stdenv.cc.targetPrefix}pkg-config\""
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Match the deployment target used by nixpkgs' Darwin libraries.
    "mac_deployment_target=\"${stdenv.hostPlatform.darwinMinVersion}\""
    "mac_min_system_version=\"${stdenv.hostPlatform.darwinMinVersion}\""

    # Keep the Apple toolchain on the system linker for now.
    "use_lld=false"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.cc.isClang) [
    # Wrapped nixpkgs Clang rejects Chromium's -fuse-ld=lld path.
    "use_lld=false"
  ]
  ++ lib.optionals stdenv.cc.isClang [
    # Chromium's raw-ptr/find-bad-constructs/unsafe-buffers plugins are built
    # into Chromium's own Clang, not generic nixpkgs or Apple Clang.
    "clang_use_chrome_plugins=false"

    # We still compile via CC/CXX from the unbundle toolchain, but Clang-
    # specific GN configs expect a Chromium-style filesystem layout with
    # headers, LLVM tools, and compiler-rt under a single root.
    "clang_base_path=\"${chromiumClang}\""
    "clang_version=\"${clangMajor}\""
  ]
  ++ lib.optionals (!stdenv.cc.isClang) [
    "is_clang=false"
  ];

  ninjaFlags = [ "pdfium" ];

  checkPhase = ''
    runHook preCheck

    buildCores=1
    if [ "''${enableParallelChecking-1}" ]; then
      buildCores="$NIX_BUILD_CORES"
    fi

    TERM=dumb ninja -j"$buildCores" pdfium_unittests pdfium_embeddertests

    ./pdfium_unittests --gtest_filter='${unitTestFilter}'
    ./pdfium_embeddertests --gtest_filter='${embedderTestFilter}'

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $dev/include $out/lib

    cp -r ../../public $dev/include/
    install -m0644 libpdfium${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      install_name_tool -id \
        "$out/lib/libpdfium${stdenv.hostPlatform.extensions.sharedLibrary}" \
        "$out/lib/libpdfium${stdenv.hostPlatform.extensions.sharedLibrary}"
    ''}

    runHook postInstall
  '';

  passthru = {
    inherit versionInfo;
    fullVersion = lib.concatStringsSep "." (
      map toString [
        versionInfo.major
        versionInfo.minor
        versionInfo.build
        versionInfo.patch
      ]
    );
    tests =
      lib.optionalAttrs stdenv.hostPlatform.isLinux {
        clang = pdfium.override {
          stdenv = llvmPackages.stdenv;
        };
      }
      // lib.optionalAttrs canCrossTest {
        cross = pkgsCross.aarch64-multiplatform.pdfium;
      }
      // lib.optionalAttrs canRunTests {
        integration = pkgsBuildHost.callPackage ./tests {
          pdfium = finalAttrs.finalPackage;
        };
        pypdfium2 = pkgsBuildHost.python3Packages.pypdfium2.override {
          pdfium = finalAttrs.finalPackage;
        };
      };
  };

  meta = {
    description = "Open-source PDF rendering library";
    homepage = "https://pdfium.googlesource.com/pdfium/";
    license =
      with lib.licenses;
      AND [
        asl20
        bsd3
        mit
      ];
    maintainers = with lib.maintainers; [ booxter ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
})
