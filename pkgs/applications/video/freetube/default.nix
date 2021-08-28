{ stdenv, lib, fetchurl, appimageTools, makeWrapper, electron }:

stdenv.mkDerivation rec {
  pname = "freetube";
  version = "0.12.0";

  src = fetchurl {
    url = "https://github.com/FreeTubeApp/FreeTube/releases/download/v${version}-beta/freetube_${version}_amd64.AppImage";
    sha256 = "151fcm1swsasrwzm93fddx669q4xlfl3d58q1w58nyv7r6kh4fda";
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

    mkdir -p $out/bin $out/share/${pname} $out/share/applications

    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/freetube.desktop $out/share/applications/${pname}.desktop
    cp -a ${appimageContents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar
  '';

  meta = with lib; {
    description = "An Open Source YouTube app for privacy";
    homepage = "https://freetubeapp.io/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ryneeverett ];
    platforms = [ "x86_64-linux" ];
  };
}
