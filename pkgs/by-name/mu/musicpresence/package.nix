{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, libGL
, libxkbcommon
, xorg
, wayland
, fontconfig
, freetype
, dbus
, glib
, libgpg-error
, e2fsprogs
, xkeyboard_config
, qt6
,
}:

stdenv.mkDerivation rec {
  pname = "musicpresence";
  version = "2.3.5";

  src = fetchurl {
    url = "https://github.com/ungive/discord-music-presence/releases/download/v${version}/musicpresence-${version}-linux-x86_64.tar.gz";
    hash = "sha256-BDgM1SfyEXC0oW+J33mYKwqRrvZX3cy/X9k7Yuk4kS8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    libGL
    libxkbcommon
    xorg.libxcb
    xorg.libX11
    wayland
    fontconfig
    freetype
    dbus
    glib
    libgpg-error
    e2fsprogs
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/share $out/
    cp -r usr/bin $out/
    rm $out/bin/musicpresence

    makeWrapper $out/share/musicpresence/bin/musicpresence $out/bin/musicpresence \
      --prefix LD_LIBRARY_PATH : $out/share/musicpresence/lib \
      --set XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb" \
      --prefix QT_PLUGIN_PATH : "${qt6.qtwayland}/${qt6.qtbase.qtPluginPrefix}" \
      --unset QT_STYLE_OVERRIDE

    runHook postInstall
  '';

  meta = {
    description = "The Discord music status that works with any media player";
    homepage = "https://github.com/ungive/discord-music-presence";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "musicpresence";
    maintainers = with lib.maintainers; [ wiyba ];
  };
}
