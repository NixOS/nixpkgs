{
  buildPackages,
  lib,
  pkgsBuildBuild,
  pkgsBuildHost,
  pdfium,
  stdenv,
  fetchurl,
  fetchzip,
  withV8 ? false,
  withXfa ? false,
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
  runCommand,
  tzdata,
  xcodebuild,
  zlib,
}:

let
  versionInfo = {
    major = 148;
    minor = 0;
    build = 7749;
    patch = 2;
  };

  version = toString versionInfo.build;
  pdfiumRef = "refs/heads/chromium/${version}";
  pdfiumHash = "sha256-RMkVffwjC8W4YwjlssNIWX1n2CAl97kE7z11yuzMX2o=";
  chromiumSrcRef = "refs/branch-heads/${version}";

  buildRev = "c9202dd8ca1d4255bd9e505988b945746ddb378a";
  buildHash = "sha256-ovdPiQ4i2sFzjiwG8vZAWVaFQ03OXNB9ZdUULU2/q9g=";
  chromiumBuildtoolsHash = "sha256-BvGCdJ3EgUZX6MC3jf86YNl4LzUxpxiptCEBv3bqBIo=";
  abseilRev = "2a7d49fc392cad55159d68d98aa3648bc89795d3";
  abseilHash = "sha256-dz2DA+bw/QQcfI9d9AKP7dn0eW0aAnhH+RmSStKS/hY=";
  dragonboxRev = "beeeef91cf6fef89a4d4ba5e95d47ca64ccb3a44";
  dragonboxHash = "sha256-j6swuGgYGfiFcK3iqd4EKTeU92rZHKTbF5T1fcak/ko=";
  fastFloatRev = "cb1d42aaa1e14b09e1452cfdef373d051b8c02a4";
  fastFloatHash = "sha256-CG5je117WYyemTe5PTqznDP0bvY5TeXn8Vu1Xh5yUzQ=";
  fp16Rev = "3d2de1816307bac63c16a297e8c4dc501b4076df";
  fp16Hash = "sha256-CR7h1d9RFE86l6btk4N8vbQxy0KQDxSMvckbiO87JEg=";
  gtestRev = "4fe3307fb2d9f86d19777c7eb0e4809e9694dde7";
  gtestHash = "sha256-gJhv3DQQSP5BQ6GmDobq42/Gkx4AbOg/ZS80bM0WpEw=";
  highwayRev = "84379d1c73de9681b54fbe1c035a23c7bd5d272d";
  highwayHash = "sha256-HNrlqtAs1vKCoSJ5TASs34XhzjEbLW+ISco1NQON+BI=";
  libcxxRev = "7ab65651aed6802d2599dcb7a73b1f82d5179d05";
  libcxxHash = "sha256-7O/X2JW8ghkPTjmFZmT9cgG3Ui5zk3gUb436KlPww34=";
  libcxxabiRev = "8f11bb1d4438d0239d0dfc1bd9456a9f31629dda";
  libcxxabiHash = "sha256-L5CUvhpOLS+NBNGssCv0pY9rsDFuAI0LlPjXQRfy62A=";
  llvmLibcRev = "044963a253be3b8b2a63a1b2e0f3e361b01bc186";
  llvmLibcHash = "sha256-J5W8ZN+E/GTPSrIOZbMW1eiw3wPiA+AB/ucEpDqYZNI=";
  generateShimHeadersHash = "sha256-tqhnqYoQeXUTN7OSSVwchpEkGJwhCUSk8TG8LUgrHdg=";
  testFontsRev = "7f51783942943e965cd56facf786544ccfc07713";
  testFontsHash = "sha256-gBnAOW/X2R13AP9507uPsvQ4A2ZUPbvzFcg3Neu3DT8=";
  testFontsBundleObject = "cd96fc55dc243f6c6f4cb63ad117cad6cd48dceb";
  testFontsBundleHash = "sha256-7Jc+zNZp1Bf78tCk2scwdEoxdCaP8GLbVFG1XIK8NJI=";
  v8Rev = "b210c794d22b5c0839ad63d8ae9129d6062168da";
  v8Hash = "sha256-C4tj4rbl5+j191gnwdBWpaOVSZmQL+DSvVJ+VxyygHo=";
  zlibRev = "7eda07b1e067ef3fd7eea0419c88b5af45c9a776";
  zlibHash = "sha256-aKDRy4AJKO2SNDDwge5iesGQCbXKzVTECoJOIBhdQco=";
  simdutfRev = "f7356eed293f8208c40b3c1b344a50bd70971983";
  simdutfHash = "sha256-l0VPVhfabaMx0oJphFjA9S1LVtavWFZ4w3btW7avCDY=";

  gclientDeps = gclient2nix.importGclientDeps (
    {
      "src" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://pdfium.googlesource.com/pdfium";
          rev = pdfiumRef;
          hash = pdfiumHash;
        };
      };

      "src/build" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/chromium/src/build.git";
          rev = buildRev;
          hash = buildHash;
        };
      };

      "src/third_party/abseil-cpp" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/chromium/src/third_party/abseil-cpp";
          rev = abseilRev;
          hash = abseilHash;
        };
      };

      # PDFium's native test targets use Chromium's googletest wrapper targets.
      "src/third_party/googletest/src" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/external/github.com/google/googletest";
          rev = gtestRev;
          hash = gtestHash;
        };
      };

      "src/third_party/fast_float/src" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/external/github.com/fastfloat/fast_float";
          rev = fastFloatRev;
          hash = fastFloatHash;
        };
      };

      "src/third_party/libc++/src" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxx.git";
          rev = libcxxRev;
          hash = libcxxHash;
        };
      };
    }
    // lib.optionalAttrs withV8 {
      "src/third_party/libc++abi/src" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxxabi.git";
          rev = libcxxabiRev;
          hash = libcxxabiHash;
        };
      };

      "src/third_party/llvm-libc/src" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libc.git";
          rev = llvmLibcRev;
          hash = llvmLibcHash;
        };
      };

      "src/third_party/dragonbox/src" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/external/github.com/jk-jeon/dragonbox.git";
          rev = dragonboxRev;
          hash = dragonboxHash;
        };
      };

      "src/third_party/fp16/src" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/external/github.com/Maratyszcza/FP16";
          rev = fp16Rev;
          hash = fp16Hash;
        };
      };

      "src/third_party/highway/src" = {
        # Chromium has an unbundle shim for highway, so this may be worth
        # switching to a system package later.
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/external/github.com/google/highway.git";
          rev = highwayRev;
          hash = highwayHash;
        };
      };

      "src/third_party/zlib" = {
        # V8 still needs Chromium's google/compression_utils_portable target
        # from this subtree even though PDFium itself uses system zlib.
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/chromium/src/third_party/zlib";
          rev = zlibRev;
          hash = zlibHash;
        };
      };

      "src/v8" = {
        fetcher = "fetchFromGitiles";
        args = {
          url = "https://chromium.googlesource.com/v8/v8";
          rev = v8Rev;
          hash = v8Hash;
        };
      };
    }
  );

  generateShimHeaders = fetchzip {
    url = "https://chromium.googlesource.com/chromium/src/+archive/${chromiumSrcRef}/tools/generate_shim_headers.tar.gz";
    hash = generateShimHeadersHash;
    stripRoot = false;
  };

  chromiumBuildtools = fetchzip {
    url = "https://chromium.googlesource.com/chromium/src/+archive/${chromiumSrcRef}/buildtools.tar.gz";
    hash = chromiumBuildtoolsHash;
    stripRoot = false;
  };

  testFonts = fetchzip {
    url = "https://chromium.googlesource.com/chromium/src/third_party/test_fonts/+archive/${testFontsRev}.tar.gz";
    hash = testFontsHash;
    stripRoot = false;
  };

  testFontsBundle = fetchurl {
    url = "https://storage.googleapis.com/chromium-fonts/${testFontsBundleObject}";
    hash = testFontsBundleHash;
  };

  simdutf = fetchzip {
    url = "https://chromium.googlesource.com/chromium/src/third_party/simdutf/+archive/${simdutfRev}.tar.gz";
    hash = simdutfHash;
    stripRoot = false;
  };

  darwinToolchainArch = if stdenv.hostPlatform.isAarch64 then "arm64" else "x64";
  chromiumToolchain =
    if stdenv.hostPlatform.isLinux then
      "//build/toolchain/linux/unbundle:default"
    else if stdenv.hostPlatform.isDarwin then
      "//build/toolchain/mac:clang_${darwinToolchainArch}"
    else
      throw "unsupported platform for pdfium";
  chromiumHostToolchain =
    if stdenv.hostPlatform.isLinux && stdenv.buildPlatform != stdenv.hostPlatform then
      "//build/toolchain/linux/unbundle:host"
    else
      chromiumToolchain;
  chromiumCpu =
    platform:
    if platform.isx86_64 then
      "x64"
    else if platform.isAarch64 then
      "arm64"
    else if platform.isi686 then
      "x86"
    else
      throw "unsupported CPU for pdfium";
  chromiumOs =
    platform:
    if platform.isLinux then
      "linux"
    else if platform.isDarwin then
      "mac"
    else
      throw "unsupported OS for pdfium";
  clangRuntimeTarget =
    if stdenv.hostPlatform.isLinux then
      stdenv.hostPlatform.config
    else if stdenv.hostPlatform.isDarwin then
      "darwin"
    else
      throw "unsupported platform for pdfium";
  compilerRtLibDir =
    if stdenv.hostPlatform.isLinux then
      "${llvmPackages.compiler-rt}/lib/linux"
    else if stdenv.hostPlatform.isDarwin then
      "${llvmPackages.compiler-rt}/lib/darwin"
    else
      throw "unsupported platform for pdfium";
  buildToolStdenv = if withV8 then buildPackages.llvmPackages.stdenv else buildPackages.stdenv;

  clangMajor = builtins.head (lib.splitVersion (lib.getVersion stdenv.cc.cc));

  pythonForBuild =
    if withV8 then
      buildPackages.python3.withPackages (ps: [
        ps.jinja2
        ps.requests
      ])
    else
      buildPackages.python3;

  icuForPdfium =
    if withV8 && stdenv.hostPlatform.isLinux then
      # V8 on Linux is built with libc++, so ICU's C++ ABI must match.
      icu.override { stdenv = llvmPackages.libcxxStdenv; }
    else
      icu;

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

  checkTargets = [
    "pdfium_unittests"
    "pdfium_embeddertests"
  ]
  ++ lib.optionals withV8 [ "pdfium_test" ];

  chromiumClang =
    runCommand "chromium-clang-${lib.getVersion stdenv.cc.cc}"
      {
        strictDeps = true;
      }
      ''
        installRuntimeDir() {
          local runtimeSrc="$1"
          local runtimeTarget="$2"
          local runtimeCpu="$3"

          mkdir -p "$out/lib/clang/${clangMajor}/lib/$runtimeTarget"

          for runtimeLib in "$runtimeSrc"/*; do
            ln -s "$runtimeLib" \
              "$out/lib/clang/${clangMajor}/lib/$runtimeTarget/$(basename "$runtimeLib")"
          done

          ${lib.optionalString stdenv.hostPlatform.isLinux ''
            # Chromium's Linux toolchain looks for unsuffixed compiler-rt names
            # in the Clang resource dir, while nixpkgs installs them with an
            # arch suffix under compiler-rt's linux output.
            for runtimeLib in \
              "$out"/lib/clang/${clangMajor}/lib/"$runtimeTarget"/libclang_rt.*-"$runtimeCpu".a \
              "$out"/lib/clang/${clangMajor}/lib/"$runtimeTarget"/libclang_rt.*-"$runtimeCpu".so; do
              if [ -e "$runtimeLib" ]; then
                runtimeBasename="$(basename "$runtimeLib")"
                ln -s "$runtimeBasename" \
                  "$out/lib/clang/${clangMajor}/lib/$runtimeTarget/''${runtimeBasename/-$runtimeCpu/}"
              fi
            done
          ''}
        }

        mkdir -p "$out/bin" "$out/lib/clang/${clangMajor}/lib/${clangRuntimeTarget}"

        ln -s ${stdenv.cc}/bin/clang "$out/bin/clang"
        ln -s ${stdenv.cc}/bin/clang++ "$out/bin/clang++"

        for tool in ${stdenv.cc.cc.libllvm}/bin/*; do
          ln -s "$tool" "$out/bin/$(basename "$tool")"
        done

        ln -s ${stdenv.cc.cc.lib}/lib/clang/${clangMajor}/include \
          "$out/lib/clang/${clangMajor}/include"

        installRuntimeDir \
          ${compilerRtLibDir} \
          ${clangRuntimeTarget} \
          ${stdenv.hostPlatform.parsed.cpu.name}
        ${lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.buildPlatform != stdenv.hostPlatform) ''
          installRuntimeDir \
            ${buildPackages.llvmPackages.compiler-rt}/lib/linux \
            ${stdenv.buildPlatform.config} \
            ${stdenv.buildPlatform.parsed.cpu.name}
        ''}
      '';
in
# PDFium's XFA parser uses V8 types directly.
assert !withXfa || withV8;
stdenv.mkDerivation (finalAttrs: {
  pname = "pdfium";
  inherit version gclientDeps;
  outputs = [
    "out"
    "dev"
  ];

  __structuredAttrs = true;

  sourceRoot = "src";
  strictDeps = true;
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  patches = [
    # Drop Clang flags that older nixpkgs Clang does not support.
    ./clang-pre-23-compat.patch
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
  ];

  nativeBuildInputs = [
    gclient2nix.gclientUnpackHook
    gn
    ninja
    pkgsBuildHost.pkg-config
    pythonForBuild
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
    icuForPdfium
    lcms2
    libjpeg
    libpng
    libtiff
    openjpeg
    zlib
  ];

  env =
    let
      cppflags = lib.concatStringsSep " " (
        lib.optionals stdenv.cc.isGNU [
          # Work around a GCC-specific build issue in Chromium/PDFium.
          # https://crbug.com/402282789
          "-ffp-contract=off"
        ]
        ++ lib.optionals (withV8 && stdenv.hostPlatform.isLinux) [
          # libpdfium links V8 into a shared library on Linux, so V8's TLS
          # accessors must use library mode instead of local-exec TLS.
          "-DV8_TLS_USED_IN_LIBRARY"
        ]
      );
    in
    lib.optionalAttrs (cppflags != "") {
      CPPFLAGS = cppflags;
    }
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      # Locale-sensitive tests expect glibc locales to be available.
      LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
      # JavaScript date/time tests set TZ themselves, but still need a
      # timezone database in the sandbox to resolve that zone name.
      TZDIR = "${tzdata}/share/zoneinfo";
    };

  postPatch = ''
    substituteInPlace BUILD.gn \
      --replace-fail 'component("pdfium")' 'shared_library("pdfium")'

    substituteInPlace public/fpdfview.h \
      --replace-fail '#if defined(COMPONENT_BUILD)' '#if defined(COMPONENT_BUILD) || defined(FPDF_IMPLEMENTATION)'

    mkdir -p third_party/icu
    cp build/linux/unbundle/icu.gn third_party/icu/BUILD.gn
    cat > third_party/icu/config.gni <<'EOF'
    declare_args() {
      icu_use_data_file = false
    }
    EOF

    # Clang builds still load helper targets from Chromium's buildtools tree
    # even when PDFium links against the system libc++.
    mkdir -p buildtools
    cp -r ${chromiumBuildtools}/. buildtools

    mkdir -p third_party/test_fonts third_party/simdutf
    cp -r ${testFonts}/. third_party/test_fonts/
    tar -xzf ${testFontsBundle} -C third_party/test_fonts
    cp -r ${simdutf}/. third_party/simdutf

    install -Dm644 ${generateShimHeaders}/generate_shim_headers.py \
      tools/generate_shim_headers/generate_shim_headers.py

    printf '%s\n' \
      'build_with_chromium = false' \
      'checkout_android = false' \
      'checkout_skia = false' \
      'checkout_testing_corpus = false' \
      'checkout_v8 = ${lib.boolToString withV8}' \
      'generate_location_tags = false' \
      > build/config/gclient_args.gni
  '';

  preConfigure = lib.optionalString stdenv.hostPlatform.isLinux ''
    # Chromium's unbundle host toolchain reads BUILD_* directly from the
    # environment rather than discovering the wrappers itself.
    export READELF="${lib.getExe' buildToolStdenv.cc.bintools "readelf"}"
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

    # Pick the Chromium toolchain that matches the host platform.
    "custom_toolchain=\"${chromiumToolchain}\""
    "host_toolchain=\"${chromiumHostToolchain}\""

    # Upstream's PDFium checkout defaults to Siso, Chromium sysroots, and
    # in-tree libc++, none of which exist in this minimal nixpkgs build.
    "use_siso=false"
    "use_sysroot=false"
    "use_custom_libcxx=false"

    # Chromium enables warnings-as-errors by default. With GCC 15 this build
    # currently trips over a _LIBCPP_HARDENING_MODE redefinition warning that
    # would otherwise stop the build.
    "treat_warnings_as_errors=false"

    # Match the requested V8 variant while keeping PartitionAlloc off.
    "pdf_enable_v8=${lib.boolToString withV8}"
    "pdf_enable_xfa=${lib.boolToString withXfa}"
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
  ++ lib.optionals withV8 (
    [
      # V8's sandbox path expects Chromium's hardened libc++, while this package
      # deliberately uses nixpkgs' system libc++.
      "v8_enable_sandbox=false"
      "v8_enable_partition_alloc=false"
      # Avoid depending on Chromium's bundled-libc++ ICU ABI in V8.
      "v8_enable_i18n_support=false"
      # libpdfium embeds V8's monolithic library into a shared library.
      "v8_monolithic_for_shared_library=true"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.buildPlatform != stdenv.hostPlatform) [
      "v8_target_cpu=\"${chromiumCpu stdenv.hostPlatform}\""
      "v8_snapshot_toolchain=\"//build/toolchain/linux/unbundle:host\""
    ]
  )
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

    TERM=dumb ninja -j"$buildCores" ${lib.concatStringsSep " " checkTargets}

    ./pdfium_unittests --gtest_filter='${unitTestFilter}'
    ./pdfium_embeddertests --gtest_filter='${embedderTestFilter}'
    ${lib.optionalString withV8 ''
      ${lib.getExe pythonForBuild} ../../testing/tools/run_javascript_tests.py \
        --build-dir out/Release \
        -j"$buildCores"
    ''}

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $dev/include $out/lib

    cp -r ../../public $dev/include/
    install -m0644 libpdfium${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/

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
    tests = lib.optionalAttrs (!withV8 && stdenv.hostPlatform.isLinux) {
      clang = pdfium.override {
        stdenv = llvmPackages.stdenv;
      };
    };
  };

  meta = {
    description = "Open-source PDF rendering library";
    homepage = "https://pdfium.googlesource.com/pdfium/";
    license =
      with lib.licenses;
      AND (
        [
          asl20
          bsd3
          mit
        ]
        ++ lib.optionals withV8 [
          # V8 compiles Chromium's bundled zlib subtree.
          lib.licenses.zlib
          # dragonbox is dual-licensed Apache-2.0 WITH LLVM-exception OR BSL-1.0.
          (OR [
            (WITH asl20 lib.licenses."llvm-exception")
            boost
          ])
        ]
        ++ lib.optionals (withV8 && stdenv.cc.isClang) [
          # Clang builds enable V8's bundled glibc trig implementation.
          lgpl21Plus
        ]
      );
    maintainers = with lib.maintainers; [ booxter ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
