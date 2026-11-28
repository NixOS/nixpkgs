{
  appimageTools,
  fetchurl,
  lib,
  stdenvNoCC,
}:
let
  pname = "nuclear";
  version = "1.56.4";

  srcs = {
    x86_64-linux = {
      url = "https://github.com/nukeop/nuclear/releases/download/player%40${version}/Nuclear_${version}_amd64.AppImage";
      hash = "sha256-gsr5Lo/+50eeMSFnoc8EqqXtWb+ktTqJewGEuoaWJpI=";
    };
    x86_64-darwin = {
      url = "https://github.com/nukeop/nuclear/releases/download/player%40${version}/Nuclear_${version}_x64.app.tar.gz";
      hash = "sha256-kbiFC/snKvPnJQVfgg3DXFGoClecBdU5cEKaTZi/5y0=";
    };
    aarch64-darwin = {
      url = "https://github.com/nukeop/nuclear/releases/download/player%40${version}/Nuclear_${version}_aarch64.app.tar.gz";
      hash = "sha256-4yeFj60zOVdWNFmIbCB6omx6q166Tz09oscwrSVOwjA=";
    };
  };

  src = fetchurl (
    srcs.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}")
  );

  meta = {
    description = "Streaming music player that finds free music for you";
    homepage = "https://nuclearplayer.com/";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.NotAShelf ];
    platforms = builtins.attrNames srcs;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "nuclear";
  };
in
if stdenvNoCC.hostPlatform.isDarwin then
  stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications
      cp -R Nuclear.app $out/Applications/
      mkdir -p $out/bin
      ln -s "$out/Applications/Nuclear.app/Contents/MacOS/nuclear-music-player" $out/bin/nuclear
      runHook postInstall
    '';
  }
else
  appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      meta
      ;

    extraInstallCommands =
      let
        contents = appimageTools.extract { inherit pname version src; };
      in
      ''
        install -m 444 -D ${contents}/Nuclear.desktop $out/share/applications/${pname}.desktop
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace-fail 'Exec=nuclear-music-player' 'Exec=${pname}'
        cp -r ${contents}/usr/share/icons $out/share
      '';
  }
