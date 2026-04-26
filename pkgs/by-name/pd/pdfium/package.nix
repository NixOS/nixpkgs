{
  lib,
  stdenv,
  fetchzip,
  freetype,
  gclient2nix,
  glib,
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
  pkg-config,
  python3,
  symlinkJoin,
  xcodebuild,
  zlib,
}:

let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);

  versionInfo = sources.version;

  version = toString versionInfo.build;
  chromiumSrcRef = "refs/branch-heads/${version}";

  gclientDeps = gclient2nix.importGclientDeps {
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
  };

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
  clangMajor = builtins.head (lib.splitVersion (lib.getVersion stdenv.cc.cc));

  chromiumClang = symlinkJoin {
    name = "chromium-clang-${lib.getVersion stdenv.cc.cc}";
    paths = [
      stdenv.cc.cc.libllvm
      stdenv.cc
    ];
  };
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
    # Let Chromium's pkg-config helper run on non-Linux hosts.
    ./pkg-config-non-linux.patch
    # Keep /nix/store paths out of the macOS SDK sysroot rewrite.
    ./pkg-config-absolute-paths.patch
  ];

  nativeBuildInputs = [
    gclient2nix.gclientUnpackHook
    gn
    ninja
    pkg-config
    python3
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
  '';

  preConfigure = lib.optionalString stdenv.hostPlatform.isLinux ''
    # Chromium's unbundle host toolchain reads BUILD_* directly from the
    # environment rather than discovering the wrappers itself.
    export BUILD_CC="$CC"
    export BUILD_CXX="$CXX"
    export BUILD_AR="$AR"
    export BUILD_NM="$NM"
  '';

  gnFlags = [
    # Build a release-style shared library rather than GN's default
    # unofficial debug configuration.
    "is_debug=false"

    # Chromium's custom_toolchain is the target/default toolchain. For native
    # Linux, unbundle expects host_toolchain to be the same :default toolchain;
    # only cross builds switch it to :host for build-machine tools.
    "custom_toolchain=\"${chromiumToolchain}\""
    "host_toolchain=\"${chromiumToolchain}\""

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
