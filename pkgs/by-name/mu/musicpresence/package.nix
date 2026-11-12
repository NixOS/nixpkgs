{
  lib,
  stdenv,
  stdenvNoCC,
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
  undmg,
}:
let
  pname = "musicpresence";
  version = "2.3.6";

  sources = {
    "x86_64-linux" = fetchurl {
      url = "https://github.com/ungive/discord-music-presence/releases/download/v${version}/musicpresence-${version}-linux-x86_64.tar.gz";
      hash = "sha256-w3y1I6nnztEMaihbXIfQqB0ng6s07iA8bqC8PDq+E+I=";
    };
    "aarch64-darwin" = fetchurl {
      url = "https://github.com/ungive/discord-music-presence/releases/download/v${version}/musicpresence-${version}-mac-arm64.dmg";
      hash = "sha256-IvUyzR9amMhyWHRuhTuqUFALCE3QTRjHmsASKydnj8Q=";
    };
  };

  meta = {
    description = "Discord music status that works with any media player";
    homepage = "https://github.com/ungive/discord-music-presence";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "musicpresence";
    maintainers = with lib.maintainers; [
      wiyba
      nonplay
      itsyunaya
    ];
  };

  linuxDrv = stdenv.mkDerivation {
    inherit pname version meta;

    src = sources.x86_64-linux;

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

    strictDeps = true;
    __structuredAttrs = true;

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
  };
in
if stdenv.hostPlatform.isLinux then
  linuxDrv
else
  stdenvNoCC.mkDerivation {
    inherit pname version meta;

    src = sources.aarch64-darwin;
    sourceRoot = ".";

    nativeBuildInputs = [
      makeWrapper
      undmg
    ];

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/Applications"
      cp -a Music\ Presence.app "$out/Applications"
      makeWrapper "$out/Applications/Music Presence.app/Contents/MacOS/Music Presence" "$out/bin/musicpresence"
      runHook postInstall
    '';
  }
