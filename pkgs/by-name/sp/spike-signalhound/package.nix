{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  unzip,
  libusb1,
  libGL,
  libx11,
  libxi,
  libsm,
  libice,
  libxcb,
  libxcb-render-util,
  libxcb-image,
  libxcb-keysyms,
  libxcb-wm,
  libxkbcommon,
  glib,
  fontconfig,
  freetype,
  libpng,
  harfbuzz,
  zlib,
  alsa-lib,
  pulseaudio,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    versionUnderscored = builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version;
    srcDir = "Spike(Ubuntu22.04x64)_${versionUnderscored}";
  in
  {
    pname = "spike-signalhound";
    version = "4.0.11";

    src = fetchurl {
      url = "https://signalhound.com/sigdownloads/Spike/Spike%28Ubuntu22.04x64%29_${versionUnderscored}.zip";
      hash = "sha256-5zM8TMJOt9w8s+feeuOOFXrnUe7JZu8SBdiBshp/qTo=";
    };

    sourceRoot = srcDir;

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      unzip
    ];

    buildInputs = [
      libusb1
      libGL
      libx11
      libxi
      libsm
      libice
      libxcb
      libxcb-render-util
      libxcb-image
      libxcb-keysyms
      libxcb-wm
      libxkbcommon
      glib
      fontconfig
      freetype
      libpng
      harfbuzz
      zlib
      alsa-lib
      pulseaudio
      stdenv.cc.cc.lib
    ];

    # MATLAB runtime is optional (only needed for LTE analysis)
    autoPatchelfIgnoreMissingDeps = [
      "libmwmclmcrrt.so.*"
    ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      # Install main binary
      install -Dm755 bin/Spike $out/opt/spike/bin/Spike

      # Install bundled libraries
      install -dm755 $out/opt/spike/lib
      install -m644 lib/*.so* $out/opt/spike/lib/

      # Remove bundled Mesa/libglvnd GL libs — use system drivers instead
      rm -f $out/opt/spike/lib/libEGL_mesa.so*
      rm -f $out/opt/spike/lib/libGLX.so*

      # Create soname symlinks for SignalHound device APIs
      ln -sf libbb_api.so.5.0.9 $out/opt/spike/lib/libbb_api.so.5
      ln -sf libsm_api.so.2.3.8 $out/opt/spike/lib/libsm_api.so.2
      ln -sf libsp_api.so.1.0.8 $out/opt/spike/lib/libsp_api.so.1
      ln -sf libpn_api.so.1.0.0 $out/opt/spike/lib/libpn_api.so.1
      ln -sf libpcr_api.so.1.0.2 $out/opt/spike/lib/libpcr_api.so.1
      ln -sf libspike_ml_api.so.1.0.0 $out/opt/spike/lib/libspike_ml_api.so.1
      ln -sf libspike_ml_api.so.1 $out/opt/spike/lib/libspike_ml_api.so

      # Create soname symlinks for bundled Qt 5.9.5
      for qtlib in Core DBus Gui Multimedia Network OpenGL PrintSupport SerialPort Widgets XcbQpa; do
        ln -sf "libQt5$qtlib.so.5.9.5" "$out/opt/spike/lib/libQt5$qtlib.so.5"
      done

      # Create soname symlinks for bundled ICU 60
      ln -sf libicudata.so.60.2 $out/opt/spike/lib/libicudata.so.60
      ln -sf libicui18n.so.60.2 $out/opt/spike/lib/libicui18n.so.60
      ln -sf libicuuc.so.60.2 $out/opt/spike/lib/libicuuc.so.60

      # Create soname symlinks for other bundled libs
      ln -sf libdouble-conversion.so.1.0 $out/opt/spike/lib/libdouble-conversion.so.1
      ln -sf libxcb-xinerama.so.0.0.0 $out/opt/spike/lib/libxcb-xinerama.so.0

      # Install Qt plugins
      cp -a plugins $out/opt/spike/plugins

      # Install udev rules for non-root USB device access
      install -Dm644 sh.rules $out/lib/udev/rules.d/99-signalhound.rules

      # Create wrapper script
      makeWrapper $out/opt/spike/bin/Spike $out/bin/spike \
        --prefix LD_LIBRARY_PATH : "$out/opt/spike/lib" \
        --set QT_PLUGIN_PATH "$out/opt/spike/plugins"

      runHook postInstall
    '';

    preFixup = ''
      addAutoPatchelfSearchPath "$out/opt/spike/lib"
    '';

    meta = {
      description = "Signal Hound spectrum analyzer software for BB60, SM200, SM435, and SP145";
      longDescription = ''
        Spike is Signal Hound's unified spectrum analyzer application for
        controlling their RF test equipment on Linux. Supports BB60, SM200,
        SM435, and SP145 series spectrum analyzers over USB.
      '';
      homepage = "https://signalhound.com/spike/";
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      maintainers = [ lib.maintainers.beeelias ];
      mainProgram = "spike";
    };
  }
)
