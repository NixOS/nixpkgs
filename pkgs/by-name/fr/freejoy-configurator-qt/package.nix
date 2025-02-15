{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  systemd,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freejoy-configurator-qt";
  version = "1.7.1b5";

  src = fetchFromGitHub {
    owner = "FreeJoy-Team";
    repo = "FreeJoyConfiguratorQt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WlSBnUQb986tMFx0H/yXpW1Eb1kgUGujfgN+bZYh4ug=";
  };

  postPatch =
    ''
      # Replace hardcoded bin install path
      substituteInPlace src/src.pro \
        --replace-fail '/opt/$$''
    + ''
      {TARGET}/bin' "$out/bin"
    '';

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    qt6.qmake
    copyDesktopItems
  ];
  buildInputs = [
    qt6.qtbase
  ] ++ (lib.optionals stdenv.isLinux [ systemd ]);

  desktopItems = [
    (makeDesktopItem {
      name = "FreeJoy Configurator";
      exec = "FreeJoyQt";
      icon = "freejoy-configurator";
      desktopName = "FreeJoy Configurator";
      comment = "FreeJoy Configuration Tool";
      categories = [ "Development" ];
    })
  ];

  postInstall = ''
    mkdir -p $out/share/pixmaps
    cp $src/src/Images/icon.png $out/share/pixmaps/freejoy-configurator.png
  '';

  meta = {
    description = "Graphical utility to configure and set up FreeJoy controllers";
    homepage = "https://github.com/FreeJoy-Team/FreeJoyConfiguratorQ";
    license = lib.licenses.gpl3Plus;
    mainProgram = "FreeJoyQt";
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.unix;
  };
})
