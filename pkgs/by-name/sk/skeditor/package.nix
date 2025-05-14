{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  makeDesktopItem,
  copyDesktopItems,
  iconConvTools,
}:
buildDotnetModule rec {
  pname = "skeditor";
  version = "2.8.9";

  src = fetchFromGitHub {
    owner = "skeditorteam";
    repo = "skeditor";
    rev = "v${version}";
    hash = "sha256-3SdE9M/2aGTVPVrFHCgHBcANyfP4zcd1svx9Jspqq0w=";
  };

  projectFile = "SkEditor/SkEditor.csproj";
  executables = [ "SkEditor" ];
  nugetDeps = ./nuget-deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nativeBuildInputs = [
    iconConvTools
    copyDesktopItems
  ];

  postInstall = ''
    icoFileToHiColorTheme SkEditor/Assets/SkEditor.ico skeditor $out
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "SkEditor";
      exec = meta.mainProgram;
      icon = "SkEditor";
      startupWMClass = "SkEditor";
      genericName = "Skript Editor";
      keywords = [
        "skeditor"
        "SkEditor"
      ];
      categories = [
        "Utility"
        "TextEditor"
        "Development"
        "IDE"
      ];
    })
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "App for editing Skript files";
    homepage = "https://github.com/SkEditorTeam/SkEditor";
    changelog = "https://github.com/SkEditorTeam/SkEditor/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "SkEditor";
    maintainers = with lib.maintainers; [ eveeifyeve ];
  };
}
