{ lib, stdenv, fetchurl, appimageTools, makeWrapper, electron_11, libsecret }:

stdenv.mkDerivation rec {
  pname = "todoist-electron";
  version = "0.2.4";

  src = fetchurl {
    url = "https://electron-dl.todoist.com/linux/Todoist-${version}.AppImage";
    sha256 = "1xrf2qjhq116z18qx7n1zd7mhvkb2dccaq7az4w6fs216l8q5zf2";
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

    mkdir -p $out/bin $out/share/${pname} $out/share/applications $out/share/icons/hicolor/512x512

    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/todoist.desktop $out/share/applications/${pname}.desktop
    cp -a ${appimageContents}/usr/share/icons/hicolor/0x0/apps $out/share/icons/hicolor/512x512

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron_11}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc libsecret ]}"
  '';

  meta = with lib; {
    homepage = "https://todoist.com";
    description = "The official Todoist electron app";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ i077 kylesferrazza ];
  };
}
