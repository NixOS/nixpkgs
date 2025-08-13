{
  stdenv,
  lib,
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
    ''target_os="linux"''
    "use_sysroot=false"
    "is_clang=false"
    "treat_warnings_as_errors=false"

    # https://github.com/signalapp/ringrtc/blob/main/bin/build-electron
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

    ''rust_sysroot_absolute="${rustc}"''
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
