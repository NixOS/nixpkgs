{ lib
, stdenv
, fetchurl
, appimageTools
, electron
, makeWrapper
}:
stdenv.mkDerivation rec{
  pname = "heynote";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/heyman/heynote/releases/download/v${version}/Heynote_${version}_x86_64.AppImage";
    hash = "sha256-KHzfoDl2MBw454N6B4p/DzUuNQVM6TGKIXyFR2TePFU=";
  };

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p  $out/bin $out/share/heynote $out/share/applications $out/share/pixmaps
    cp -a ${appimageContents}/{locales,resources} $out/share/heynote
    install -Dm 444 ${appimageContents}/heynote.desktop $out/share/applications/heynote.desktop
    install -Dm 444 ${appimageContents}/usr/share/icons/hicolor/0x0/apps/heynote.png $out/share/pixmaps/heynote.png

    substituteInPlace $out/share/applications/heynote.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=heynote'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${lib.getExe electron} $out/bin/heynote \
      --add-flags $out/share/heynote/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';

  meta = with lib; {
    description = "A dedicated scratchpad for developers";
    homepage = "https://github.com/heyman/heynote";
    changelog = "https://github.com/heyman/heynote/releases/tag/v${version}";
    license = licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Ligthiago ];
    mainProgram = "heynote";
  };
}
