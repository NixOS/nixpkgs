{ stdenvNoCC
, lib
, fetchurl
, fetchzip
, appimageTools
, makeWrapper
, electron
}:
(stdenvNoCC.mkDerivation {
  pname = "revolt-desktop";
  version = "1.0.6";
  dontConfigure = true;
  dontBuild = true;
  meta = with lib; {
    description = "Open source user-first chat platform";
    homepage = "https://revolt.chat/";
    changelog = "https://github.com/revoltchat/desktop/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      heyimnova
      caralice
    ];
    platforms = platforms.linux ++ platforms.darwin;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "revolt-desktop";
  };
  nativeBuildInputs = [ makeWrapper ];
}).overrideAttrs
  (
    final: prev:
    let
      inherit (prev) pname version;
    in
    if stdenvNoCC.hostPlatform.isLinux then
      {
        src = fetchurl {
          url = "https://github.com/revoltchat/desktop/releases/download/v${version}/Revolt-linux.AppImage";
          hash = "sha256-Wsm6ef2Reenq3/aKGaP2yzlOuLKaxKtRHCLLMxvWUUY=";
        };

        appimageContents = appimageTools.extractType2 { inherit (final) src pname version; };

        dontUnpack = true;

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin $out/share/{applications,revolt-desktop}

          cp -a ${final.appimageContents}/{locales,resources} $out/share/revolt-desktop
          cp -a ${final.appimageContents}/revolt-desktop.desktop $out/share/applications/revolt-desktop.desktop
          cp -a ${final.appimageContents}/usr/share/icons $out/share/icons

          substituteInPlace $out/share/applications/revolt-desktop.desktop \
            --replace 'Exec=AppRun' 'Exec=revolt-desktop'

          runHook postInstall
        '';

        postFixup = ''
          makeWrapper ${electron}/bin/electron $out/bin/revolt-desktop \
            --add-flags $out/share/revolt-desktop/resources/app.asar \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}"
        '';
      }
    else
      assert stdenvNoCC.hostPlatform.isDarwin;
      {
        src = fetchzip {
          url = "https://github.com/revoltchat/desktop/releases/download/v${version}/Revolt-${version}-mac.zip";
          hash = "sha256-XxmKcIfJtHfi6SahrRHMeTAuyVqiN9Yhayjis10vD2w=";
          stripRoot = false;
        };

        installPhase = ''
          runHook preInstall

          mkdir -p "$out/Applications/" "$out/bin/"
          mv Revolt.app "$out/Applications/"
          makeWrapper "$out/Applications/Revolt.app/Contents/MacOS/Revolt" "$out/bin/revolt-desktop"

          runHook postInstall
        '';
      }
  )
