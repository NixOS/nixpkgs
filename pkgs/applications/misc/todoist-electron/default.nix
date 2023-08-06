{ lib, stdenv, fetchurl, appimageTools, makeWrapper, electron_24, libsecret }:

stdenv.mkDerivation rec {
  pname = "todoist-electron";
  version = "8.3.3";

  src = fetchurl {
    url = "https://electron-dl.todoist.com/linux/Todoist-linux-x86_64-${version}.AppImage";
    hash = "sha256-X928hCrYVOBTEZq1hmZWgWlabtOzQrLUuptF/SJcAto=";
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
    cp -a ${appimageContents}/usr/share/icons/hicolor/512x512/apps $out/share/icons/hicolor/512x512

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron_24}/bin/electron $out/bin/todoist-electron \
      --add-flags $out/share/${pname}/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc libsecret ]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';

  meta = with lib; {
    homepage = "https://todoist.com";
    description = "The official Todoist electron app";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ i077 kylesferrazza ];
  };
}
