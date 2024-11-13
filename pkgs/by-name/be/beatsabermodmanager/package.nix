{
  lib,
  buildDotnetModule,
  fetchFromGitHub,

  dotnetCorePackages,

  xdg-utils,
}:

buildDotnetModule {
  pname = "beatsabermodmanager";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "affederaffe";
    repo = "BeatSaberModManager";
    # v0.0.7 was published without a release tag
    rev = "8bf3611a8b33c95e7a0340504894cf7b46822107";
    hash = "sha256-mRC/dGkpmKBQ2euyCOOvOkN+LUOHW1p1L/VQ4bWSUpY";
    fetchSubmodules = true; # It vendors BSIPA-Linux
  };

  dotnet-sdk =
    with dotnetCorePackages;
    combinePackages [
      sdk_8_0
      sdk_6_0
    ];

  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  projectFile = [ "BeatSaberModManager/BeatSaberModManager.csproj" ];

  executables = [ "BeatSaberModManager" ];

  nugetDeps = ./deps.nix;

  # Required for OneClick
  makeWrapperArgs = [
    ''--suffix PATH : "${lib.makeBinPath [ xdg-utils ]}"''
  ];

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
