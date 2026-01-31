{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  libGL,
  libxcb,
  libx11,
  wayland,
  fontconfig,
  freetype,
  libgpg-error,
  e2fsprogs,
  xkeyboard_config,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "musicpresence";
  version = "2.3.5";

  src = fetchurl {
    url = "https://github.com/ungive/discord-music-presence/releases/download/v${finalAttrs.version}/musicpresence-${finalAttrs.version}-linux-x86_64.tar.gz";
    hash = "sha256-BDgM1SfyEXC0oW+J33mYKwqRrvZX3cy/X9k7Yuk4kS8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    libGL
    libxcb
    libx11
    wayland
    fontconfig
    freetype
    libgpg-error
    e2fsprogs
    stdenv.cc.cc.lib
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r usr/share $out/

    makeWrapper $out/share/musicpresence/bin/musicpresence $out/bin/musicpresence \
      --set XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb" \
      --prefix QT_PLUGIN_PATH : "${qt6.qtwayland}/${qt6.qtbase.qtPluginPrefix}" \
      --unset QT_STYLE_OVERRIDE

    runHook postInstall
  '';

  meta = {
    description = "Discord music status that works with any media player";
    homepage = "https://github.com/ungive/discord-music-presence";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "musicpresence";
    maintainers = with lib.maintainers; [
      wiyba
      nonplay
    ];
  };
})
