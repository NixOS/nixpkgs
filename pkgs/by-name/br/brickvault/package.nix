{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  makeDesktopItem,
  copyDesktopItems,
}:
buildDotnetModule (
  finalAttrs:
  let
    BrickVault-source = fetchFromGitHub {
      owner = "connorh315";
      repo = "BrickVault";
      tag = "v${finalAttrs.version}";
      hash = "sha256-psVlD5T5DZx15O2TuXsSg3UIhj0zVK4p+gckk3EdM7U=";
    };
  in
  {
    strictDeps = true;
    __structuredAttrs = true;

    pname = "brickvault";
    version = "1.2.1";
    src = fetchFromGitHub {
      owner = "connorh315";
      repo = "BrickVaultApp";
      rev = "6ccfe16632ec1c1e547a4cac27432d52efc4254f";
      hash = "sha256-yTaTtaiDlxBMcdOvDIvrSrGM3HBT9KTwj5eKqvxHDGg=";
    };

    postUnpack = ''
      cp -r ${BrickVault-source} BrickVault
      chmod -R +w BrickVault
    '';

    patches = [
      ./csproj.patch
      ./ui-version.patch
    ];

    projectFile = "BrickVaultApp.csproj";
    nugetDeps = ./deps.json;

    dotnet-sdk = dotnetCorePackages.sdk_8_0;

    nativeBuildInputs = [ copyDesktopItems ];
    postInstall = "install -Dm644 ${BrickVault-source}/Images/brickvaultico.png $out/share/icons/hicolor/1024x1024/apps/BrickVault.png";

    desktopItems = [
      (makeDesktopItem {
        name = "brickvault";
        desktopName = "BrickVault";
        comment = "Archive extractor for LEGO TTGames";
        icon = "BrickVault";
        exec = "BrickVaultApp";
        terminal = false;
        startupWMClass = "BrickVaultApp";
        categories = [
          "Utility"
          "FileTools"
          "Archiving"
        ];
        keywords = [
          "LEGO"
          "TT Games"
          "DAT"
          "Archive"
          "Extractor"
          "Viewer"
          "Asset"
          "Resource"
          "Game"
        ];
      })
    ];

    meta = with lib; {
      description = "Archive extractor for LEGO TTGames";
      homepage = "https://github.com/connorh315/BrickVault";
      license = licenses.unfree; # no license
      mainProgram = "BrickVaultApp";
      maintainers = with maintainers; [ justdeeevin ];
      platforms = platforms.all;
    };
  }
)
