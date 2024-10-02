{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,

  dotnetCorePackages,

  xdg-utils,
}:

buildDotnetModule rec {
  pname = "beatsabermodmanager";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "affederaffe";
    repo = "BeatSaberModManager";
    rev = "v${version}";
    hash = "sha256-HHWC+MAwJ+AMCuBzSuR7FbW3k+wLri0B9J1DftyfNEU=";
    fetchSubmodules = true; # It vendors BSIPA-Linux
  };

  dotnet-sdk = with dotnetCorePackages; combinePackages [
    sdk_7_0
    sdk_6_0
  ];

  dotnet-runtime = dotnetCorePackages.runtime_7_0;

  nativeBuildInputs = [ copyDesktopItems ];

  projectFile = [ "BeatSaberModManager/BeatSaberModManager.csproj" ];

  executables = [ "BeatSaberModManager" ];

  nugetDeps = ./deps.nix;

  preConfigureNuGet = ''
    # This should really be in the upstream nuget.config
    dotnet nuget add source https://api.nuget.org/v3/index.json \
      -n nuget.org --configfile nuget.config
  '';

  # Required for OneClick
  makeWrapperArgs = [
    ''--suffix PATH : "${lib.makeBinPath [ xdg-utils ]}"''
  ];

  desktopItems =
    [
      (makeDesktopItem {
        name = "BeatSaberModManager";
        desktopName = "BeatSaberModManager";
        exec = "BeatSaberModManager";
        # icon = "osu!";
        comment = meta.description;
        type = "Application";
        categories = [
          "Game"
          "Utility"
        ];
      })
    ]
    ++ (map
      (
        protocol:
        makeDesktopItem {
          name = "BeatSaberModManager-url-${protocol}";
          desktopName = "BeatSaberModManager";
          comment = "URL:${protocol} Protocol";
          type = "Application";
          categories = [ "Utility" ];
          exec = "BeatSaberModManager --install %u";
          terminal = false;
          noDisplay = true;
          mimeTypes = [ "x-scheme-handler/${protocol}" ];
        }
      )
      [
        "beatsaver"
        "modelsaber"
        "bsplaylist"
      ]
    );

  meta = with lib; {
    description = "Yet another mod installer for Beat Saber, heavily inspired by ModAssistant";
    mainProgram = "BeatSaberModManager";
    homepage = "https://github.com/affederaffe/BeatSaberModManager";
    longDescription = ''
      BeatSaberModManager is yet another mod installer for Beat Saber, heavily inspired by ModAssistant
      It strives to look more visually appealing and support both Windows and Linux, while still being as feature-rich as ModAssistant.

      Features

      - Windows and Linux support
      - Dependency resolution
      - Installed mod detection
      - Mod uninstallation
      - Theming support
      - OneClick™ support for BeatSaver, ModelSaber and Playlists
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ atemu ];
    platforms = with platforms; linux;
  };
}
