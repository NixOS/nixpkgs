{
  stdenvNoCC,
  lib,
  makeDesktopItem,
  makeWrapper,
  copyDesktopItems,
  coreutils,
  findutils,
  zenity,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  name = "lug-helper";
  version = "2.18";
  src = fetchFromGitHub {
    owner = "starcitizen-lug";
    repo = "lug-helper";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-x6o9hNXadlZrww5+a9xZtNfRwxKuTO/O9M9iYvhMIYc=";
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
    install -Dm644 lug-logo.png $out/share/pixmaps/lug-logo.png
    install -Dm644 lib/* -t $out/share/lug-helper

    wrapProgram $out/bin/lug-helper \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          findutils
          zenity
        ]
      }

  '';
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Script to manage and optimize Star Citizen on Linux";
    homepage = "https://github.com/starcitizen-lug/lug-helper";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fuzen ];
    platforms = lib.platforms.linux;
    mainProgram = "lug-helper";
  };
})
