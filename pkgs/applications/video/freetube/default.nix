{ stdenv, lib, fetchurl, appimageTools, makeWrapper, electron_22 }:

stdenv.mkDerivation rec {
  pname = "freetube";
  version = "0.19.1";

  src = fetchurl {
    url = "https://github.com/FreeTubeApp/FreeTube/releases/download/v${version}-beta/freetube_${version}_amd64.AppImage";
    sha256 = "add96ad3509d4d5c6d8658b005dfd046963cd6bb0a4e1f3e88f726a86c05810f";
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

    mkdir -p $out/bin $out/share/${pname} $out/share/applications $out/share/icons/hicolor/scalable/apps

    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/freetube.desktop $out/share/applications/${pname}.desktop
    cp -a ${appimageContents}/usr/share/icons/hicolor/scalable/freetube.svg $out/share/icons/hicolor/scalable/apps

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    runHook postInstall
  '';

  # Electron version is set to 22 in order to match upstream
  postFixup = ''
    makeWrapper ${electron_22}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar
  '';

  meta = with lib; {
    description = "An Open Source YouTube app for privacy";
    homepage = "https://freetubeapp.io/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ryneeverett alyaeanyx ];
    inherit (electron_22.meta) platforms;
  };
}
