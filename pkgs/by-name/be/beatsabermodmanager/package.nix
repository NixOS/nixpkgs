{
  lib,
  buildDotnetModule,
  fetchFromGitHub,

  dotnetCorePackages,

  nix-update-script,
  testers,
  xdg-utils,
}:

buildDotnetModule (finalAttrs: rec {
  pname = "beatsabermodmanager";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "affederaffe";
    repo = "BeatSaberModManager";
    rev = "v${version}";
    hash = "sha256-f7W3GTACxZ+FuCXCm20V8aDrJcsSBMNTUtxtFLPh8DY=";
    fetchSubmodules = true; # It vendors BSIPA-Linux
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  projectFile = [ "BeatSaberModManager/BeatSaberModManager.csproj" ];

  executables = [ "BeatSaberModManager" ];

  nugetDeps = ./deps.nix;

  # Required for OneClick
  makeWrapperArgs = [
    ''--suffix PATH : "${lib.makeBinPath [ xdg-utils ]}"''
  ];

  passthru.updateScript = nix-update-script { };

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
})
