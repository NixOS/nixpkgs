{
  stdenv,
  lib,
  buildPackages,
  ninja,
  gn,
  python3,
  pkg-config,
  glib,
  alsa-lib,
  pulseaudio,
  writeShellScriptBin,
  gclient2nix,
  rustc,
}:

let
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
  version = finalAttrs.gclientDeps."src".path.rev;

  gclientDeps = gclient2nix.importGclientDeps ./webrtc-sources.json;
  sourceRoot = "src";

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
  ];

  buildInputs = [
    glib
    alsa-lib
    pulseaudio
  ];

  patches = [
    ./webrtc-fix-gcc-build.patch
  ];

  postPatch = ''
    substituteInPlace build/toolchain/linux/BUILD.gn \
      --replace-fail 'toolprefix = "aarch64-linux-gnu-"' 'toolprefix = ""'
    patchShebangs build/mac/should_use_hermetic_xcode.py

    substituteInPlace modules/audio_device/linux/pulseaudiosymboltable_linux.cc \
      --replace-fail "libpulse.so.0" "${pulseaudio}/lib/libpulse.so.0"
    substituteInPlace modules/audio_device/linux/alsasymboltable_linux.cc \
      --replace-fail "libasound.so.2" "${alsa-lib}/lib/libasound.so.2"
  '';

  preConfigure = ''
    echo "$SOURCE_DATE_EPOCH" > build/util/LASTCHANGE.committime
    echo "generate_location_tags = true" >> build/config/gclient_args.gni
  '';

  gnFlags = [
    # webrtc uses chromium's `src/build/BUILDCONFIG.gn`. many of these flags
    # are copied from pkgs/applications/networking/browsers/chromium/common.nix.
    ''target_os="linux"''
    ''target_cpu="${chromiumRosettaStone.cpu stdenv.hostPlatform}"''
    ''pkg_config="${stdenv.cc.targetPrefix}pkg-config"''
    "use_sysroot=false"
    "is_clang=false"
    "treat_warnings_as_errors=false"
    "use_llvm_libatomic=false"

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

    ''rust_sysroot_absolute="${buildPackages.rustc}"''

    # Build using the system toolchain (for Linux distributions):
    #
    # What you would expect to be called "target_toolchain" is
    # actually called either "default_toolchain" or "custom_toolchain",
    # depending on which part of the codebase you are in; see:
    # https://chromium.googlesource.com/chromium/src/build/+/3c4595444cc6d514600414e468db432e0f05b40f/config/BUILDCONFIG.gn#17
    ''custom_toolchain="//build/toolchain/linux/unbundle:default"''
    ''host_toolchain="//build/toolchain/linux/unbundle:default"''
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
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
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
