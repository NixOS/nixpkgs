{
  stdenv,
  lib,
  fetchpatch,
  buildPackages,
  ninja,
  gn,
  symlinkJoin,
  python3,
  pkg-config,
  glib,
  alsa-lib,
  pulseaudio,
  writeShellScriptBin,
  gclient2nix,
  rustc,
  apple-sdk,
  xcodebuild,
  llvmPackages,
}:

let
  llvmCcAndBintools = symlinkJoin {
    name = "signal-webrtc-llvm-cc-and-bintools";
    paths = [
      llvmPackages.llvm
      llvmPackages.stdenv.cc
    ];
  };

  chromiumRosettaStone = {
    cpu =
      platform:
      let
        name = platform.parsed.cpu.name;
      in
      (
        {
          "x86_64" = "x64";
          "i686" = "x86";
          "arm" = "arm";
          "aarch64" = "arm64";
        }
        .${name} or (throw "no chromium Rosetta Stone entry for cpu: ${name}")
      );
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "signal-webrtc";
  version = finalAttrs.gclientDeps."src".path.tag;

  gclientDeps = gclient2nix.importGclientDeps ./webrtc-sources.json;
  sourceRoot = "src";

  # Chromium's Darwin toolchain defines _LIBCPP_HARDENING_MODE itself; keep
  # cc-wrapper from injecting a conflicting default.
  hardeningDisable = lib.optionals stdenv.hostPlatform.isDarwin [
    "libcxxhardeningfast"
    "libcxxhardeningextensive"
  ];

  nativeBuildInputs = [
    gn
    ninja
    (writeShellScriptBin "vpython3" ''
      exec python3 "$@"
    '')
    python3
    rustc
    pkg-config
    gclient2nix.gclientUnpackHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk
    xcodebuild
  ];

  buildInputs = [
    glib
    pulseaudio
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.compiler-rt
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  patches = [
    # https://github.com/NixOS/nixpkgs/blob/8e689a91c5b4e47b57dee488dd7e319cc704eb9d/pkgs/applications/networking/browsers/chromium/common.nix#L604-L612
    # clang++: error: unknown argument: '-fsanitize-ignore-for-ubsan-feature=array-bounds'
    (fetchpatch {
      name = "chromium-146-revert-Update-fsanitizer=array-bounds-config.patch";
      # https://chromium-review.googlesource.com/c/chromium/src/+/7539408
      url = "https://chromium.googlesource.com/chromium/src/+/acb47d9a6b56c4889a2ed4216e9968cfc740086c^!?format=TEXT";
      decode = "base64 -d";
      revert = true;
      hash = "sha256-WZsN2qm6lX121bDf7SoN75flXtCTmPPpwtHK0ayjkPc=";
    })

    # https://github.com/NixOS/nixpkgs/blob/8e689a91c5b4e47b57dee488dd7e319cc704eb9d/pkgs/applications/networking/browsers/chromium/common.nix#L620-L623
    # clang++: error: unknown argument: '-fno-lifetime-dse'
    ./chromium-147-llvm-22.patch

    # https://github.com/NixOS/nixpkgs/blob/8e689a91c5b4e47b57dee488dd7e319cc704eb9d/pkgs/applications/networking/browsers/chromium/common.nix#L624-L644
    # clang++: error: unknown argument: '-fsanitize-ignore-for-ubsan-feature=return'
    (fetchpatch {
      name = "chromium-148-revert-build-Add--fsanitizer=return-config.patch";
      # https://chromium-review.googlesource.com/c/chromium/src/+/7629257
      url = "https://chromium.googlesource.com/chromium/src/+/99ba1f5302f9433efdb4df302cb7b7de56c72e4c^!?format=TEXT";
      decode = "base64 -d";
      revert = true;
      hash = "sha256-/qzzxwTdPMwIdsqD/G02S7kKHCj3QxECL+g1WYEaWmU=";
    })
    # ERROR Unresolved dependencies.
    # //apps:apps(//build/toolchain/linux/unbundle:default)
    #   needs //build/config/compiler:sanitize_return(//build/toolchain/linux/unbundle:default)
    (fetchpatch {
      name = "chromium-148-revert-build-Enable--fsanitizer=return-config.patch";
      # https://chromium-review.googlesource.com/c/chromium/src/+/7629258
      url = "https://chromium.googlesource.com/chromium/src/+/9357bfbea03753fe52264c9ec36abe74f48cfef5^!?format=TEXT";
      decode = "base64 -d";
      revert = true;
      hash = "sha256-14fTHNh3vGsf4KgeH8uLX+aK3lrjK0VKd1dfK1g7r0I=";
    })
  ];

  postPatch = ''
    substituteInPlace build/toolchain/linux/BUILD.gn \
      --replace-fail 'toolprefix = "aarch64-linux-gnu-"' 'toolprefix = ""'

    substituteInPlace modules/audio_device/linux/pulseaudiosymboltable_linux.cc \
      --replace-fail "libpulse.so.0" "${pulseaudio}/lib/libpulse.so.0"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Fix Darwin Python script shebangs for sandbox builds
    patchShebangs build/mac/should_use_hermetic_xcode.py build/toolchain/apple/linker_driver.py

    substituteInPlace build/config/clang/BUILD.gn \
      --replace-fail '_clang_lib_dir = "$clang_base_path/lib/clang/$clang_version/lib"' \
                     '_clang_lib_dir = "${llvmPackages.compiler-rt}/lib"'

    # Keep target triple aligned with nix cc-wrapper expectations to avoid
    # arm64-apple-macos vs arm64-apple-darwin warning spam.
    substituteInPlace build/config/mac/BUILD.gn \
      --replace-fail "apple-macos" "apple-darwin"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace modules/audio_device/linux/alsasymboltable_linux.cc \
      --replace-fail "libasound.so.2" "${alsa-lib}/lib/libasound.so.2"
  '';

  preConfigure = ''
    echo "$SOURCE_DATE_EPOCH" > build/util/LASTCHANGE.committime
    echo "generate_location_tags = true" >> build/config/gclient_args.gni
  '';

  gnFlags =
    lib.optionals stdenv.hostPlatform.isLinux [
      # webrtc uses chromium's `src/build/BUILDCONFIG.gn`. many of these flags
      # are copied from pkgs/applications/networking/browsers/chromium/common.nix.
      ''target_os="linux"''
      ''pkg_config="${stdenv.cc.targetPrefix}pkg-config"''
      "use_sysroot=false"
      "is_clang=false"

      # Build using the system toolchain (for Linux distributions):
      #
      # What you would expect to be called "target_toolchain" is
      # actually called either "default_toolchain" or "custom_toolchain",
      # depending on which part of the codebase you are in; see:
      # https://chromium.googlesource.com/chromium/src/build/+/3c4595444cc6d514600414e468db432e0f05b40f/config/BUILDCONFIG.gn#17
      ''custom_toolchain="//build/toolchain/linux/unbundle:default"''
      ''host_toolchain="//build/toolchain/linux/unbundle:default"''
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      ''target_os="mac"''
      ''mac_deployment_target="${stdenv.hostPlatform.darwinMinVersion}"''
      "use_sysroot=true"
      "is_clang=true"
      "use_lld=false"
      "clang_use_chrome_plugins=false"
      "clang_use_raw_ptr_plugin=false"
      "use_clang_modules=false"
      ''clang_base_path="${llvmCcAndBintools}"''
      ''custom_toolchain="//build/toolchain/mac:clang_${chromiumRosettaStone.cpu stdenv.hostPlatform}"''
    ]
    ++ [
      ''target_cpu="${chromiumRosettaStone.cpu stdenv.hostPlatform}"''
      # https://github.com/signalapp/ringrtc/blob/main/bin/build-desktop
      "rtc_build_examples=false"
      "rtc_build_tools=false"
      "rtc_use_x11=false"
      "rtc_enable_sctp=false"
      "rtc_libvpx_build_vp9=true"
      "rtc_disable_metrics=true"
      "rtc_disable_trace_events=true"
      "is_debug=false"
      "symbol_level=1"
      "rtc_include_tests=false"
      "rtc_enable_protobuf=false"
      "treat_warnings_as_errors=false"
      "use_llvm_libatomic=false"
      "use_custom_libcxx=false"
      ''rust_sysroot_absolute="${buildPackages.rustc}"''
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.buildPlatform != stdenv.hostPlatform) [
      ''host_toolchain="//build/toolchain/linux/unbundle:host"''
      ''v8_snapshot_toolchain="//build/toolchain/linux/unbundle:host"''
    ];
  ninjaFlags = [ "webrtc" ];

  installPhase = ''
    runHook preInstall

    install -D obj/libwebrtc${stdenv.hostPlatform.extensions.staticLibrary} $out/lib/libwebrtc${stdenv.hostPlatform.extensions.staticLibrary}

    runHook postInstall
  '';

  meta = {
    description = "WebRTC library used by Signal";
    homepage = "https://github.com/SignalApp/webrtc";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
