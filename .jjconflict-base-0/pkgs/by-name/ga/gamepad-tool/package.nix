{
  stdenvNoCC,
  fetchurl,
  dpkg,
  lib,
  qt5,
  autoPatchelfHook,
  SDL2,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gamepad-tool";
  version = "1.2";

  src = fetchurl {
    url = "https://generalarcade.com/gamepadtool/linux/gamepadtool_${finalAttrs.version}_amd64.deb";
    hash = "sha256-ZuB0TOyT2B5QkU1o5h3/8PL85tBq06hlz5YclRanD88=";
  };

  nativeBuildInputs = [
    dpkg
    qt5.wrapQtAppsHook
    autoPatchelfHook
  ];

  dontBuild = true;

  buildInputs = [
    SDL2
    qt5.qtbase
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications
    cp usr/bin/gamepad-tool $out/bin
    cp -r usr/share/icons $out/share/icons
    substitute usr/share/applications/gamepad-tool-debian.desktop \
      $out/share/applications/gamepad-tool.desktop \
      --replace-fail "/usr/share/icons/hicolor/256x256/apps/gamepad-tool.png" "gamepad-tool"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Simple GUI tool to create/modify gamepad mappings for games that use SDL2 Game Controller API";
    homepage = "https://generalarcade.com/gamepadtool/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ gador ];
    mainProgram = "gamepad-tool";
  };
})
