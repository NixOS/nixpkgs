{
  stdenvNoCC,
  lib,
  makeDesktopItem,
  makeWrapper,
  copyDesktopItems,
  coreutils,
  findutils,
  zenity,
  unzip,
  cabextract,
  libnotify,
  winetricks,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lug-helper";
  version = "4.6";
  src = fetchFromGitHub {
    owner = "starcitizen-lug";
    repo = "lug-helper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E8SSsAI9GvTTY121si6SsnbxXnlcc05nB+USrOdCDOw=";
  };

  buildInputs = [
    coreutils
    findutils
    zenity
  ];

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "lug-helper";
      exec = "lug-helper";
      icon = "lug-logo";
      comment = "Star Citizen LUG Helper";
      desktopName = "LUG Helper";
      categories = [ "Utility" ];
      mimeTypes = [ "application/x-lug-helper" ];
    })
  ];

  postInstall = ''
    install -Dm755 lug-helper.sh $out/bin/lug-helper
    install -Dm644 lug-logo.png $out/share/icons/hicolor/256x256/apps/lug-logo.png
    install -Dm644 rsi-launcher.png $out/share/icons/hicolor/256x256/apps/rsi-launcher.png
    install -Dm644 lib/* -t $out/share/lug-helper

    wrapProgram $out/bin/lug-helper \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          findutils
          zenity
          cabextract
          unzip
          libnotify
          winetricks
        ]
      } \
      --prefix XDG_DATA_DIRS : "$out"

  '';
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Script to manage and optimize Star Citizen on Linux";
    homepage = "https://github.com/starcitizen-lug/lug-helper";
    changelog = "https://github.com/starcitizen-lug/lug-helper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fuzen ];
    platforms = lib.platforms.linux;
    mainProgram = "lug-helper";
  };
})
