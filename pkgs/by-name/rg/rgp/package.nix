{
  lib,
  stdenv,
  makeWrapper,
  fetchurl,
  autoPatchelfHook,
  dbus,
  directx-shader-compiler,
  fontconfig,
  freetype,
  glib,
  libdrm,
  libGLU,
  libglvnd,
  libice,
  libkrb5,
  libsm,
  libx11,
  libxcb,
  libxi,
  libxkbcommon,
  libxml2_13,
  ncurses,
  wayland,
  libxcb-util,
  zlib,
  zstd,
}:

let
  buildNum = "2025-12-08-1746";
in
stdenv.mkDerivation {
  pname = "rgp";
  version = "2.6.1";

  src = fetchurl {
    url = "https://gpuopen.com/download/RadeonDeveloperToolSuite-${buildNum}.tgz";
    hash = "sha256-rfFZPA8DzgP5axSHToEBvhRTgWAejn/z0WlLMectya0=";
  };

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    dbus
    directx-shader-compiler
    fontconfig
    freetype
    glib
    libdrm
    libGLU
    libglvnd
    libice
    libkrb5
    libsm
    libx11
    libxcb
    libxi
    libxkbcommon
    libxml2_13
    ncurses
    wayland
    libxcb-util
    zlib
    zstd
  ];

  installPhase = ''
    mkdir -p $out/opt/rgp $out/bin
    cp -r . $out/opt/rgp/

    chmod +x $out/opt/rgp/scripts/*
    patchShebangs $out/opt/rgp/scripts

    for prog in RadeonDeveloperPanel RadeonDeveloperService RadeonDeveloperServiceCLI RadeonGPUAnalyzer RadeonGPUProfiler RadeonMemoryVisualizer RadeonRaytracingAnalyzer rga rtda; do
      # makeWrapper is needed so that executables are started from the opt
      # directory, where qt.conf and other tools are.
      # Unset Qt theme, it does not work if the nixos Qt version is different from the packaged one.
      makeWrapper \
        $out/opt/rgp/$prog \
        $out/bin/$prog \
        --unset QT_QPA_PLATFORMTHEME \
        --unset QT_STYLE_OVERRIDE \
        --prefix LD_LIBRARY_PATH : $out/opt/rgp/lib
    done
  '';

  meta = {
    description = "Tool from AMD that allows for deep inspection of GPU workloads";
    homepage = "https://gpuopen.com/rgp/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ Flakebi ];
  };
}
