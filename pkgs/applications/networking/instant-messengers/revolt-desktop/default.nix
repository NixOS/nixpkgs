{ stdenv
, lib
, fetchurl
, appimageTools
, makeWrapper
, electron
}:

stdenv.mkDerivation rec {
  pname = "revolt-desktop";
  version = "1.0.6";

  src = fetchurl {
    url = "https://github.com/revoltchat/desktop/releases/download/v${version}/Revolt-linux.AppImage";
    sha256 = "sha256-Wsm6ef2Reenq3/aKGaP2yzlOuLKaxKtRHCLLMxvWUUY=";
  };

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/{applications,revolt-desktop}

    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/revolt-desktop.desktop $out/share/applications/${pname}.desktop
    cp -a ${appimageContents}/usr/share/icons $out/share/icons

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar
  '';

  meta = with lib; {
    description = "An open source user-first chat platform";
    homepage = "https://revolt.chat/";
    changelog = "https://github.com/revoltchat/desktop/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ heyimnova ];
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "revolt-desktop";
  };
}
