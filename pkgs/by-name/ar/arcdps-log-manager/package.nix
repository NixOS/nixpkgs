{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  wrapGAppsHook3,
  gtk3,
  libnotify,
  icoutils,
  nix-update-script,
  copyDesktopItems,
  makeDesktopItem,
}:
buildDotnetModule (finalAttrs: {
  pname = "arcdps-log-manager";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "gw2scratch";
    repo = "evtc";
    tag = "manager-v${finalAttrs.version}";
    hash = "sha256-z7SuE+MPhN4/XW3CtYabbAd2ZjL2M/ii+VCdyUUukoA=";
  };

  nugetDeps = ./deps.json;

  projectFile = "ArcdpsLogManager.Gtk/ArcdpsLogManager.Gtk.csproj";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nativeBuildInputs = [
    wrapGAppsHook3
    icoutils
    copyDesktopItems
  ];

  runtimeDeps = [
    gtk3
    libnotify
  ];

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/128x128/apps
    icotool -x $src/ArcdpsLogManager/Images/program_icon.ico
    cp program_icon_1_128x128x32.png $out/share/icons/hicolor/128x128/apps/arcdps-log-manager.png
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "arcdps Log Manager";
      genericName = "arcdps Log Manager";
      exec = "GW2Scratch.ArcdpsLogManager.Gtk";
      name = "arcdps Log Manager";
      icon = "arcdps-log-manager";
    })
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=manager-v(.*)" ];
  };

  meta = {
    description = "Manager for Guild Wars 2 log files";
    longDescription = ''
      Manager for all your recorded logs. Filter logs, upload them with one click, find interesting statistics.
    '';
    homepage = "https://gw2scratch.com/tools/manager";
    changelog = "https://github.com/gw2scratch/evtc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.Blu3 ];
    mainProgram = "GW2Scratch.ArcdpsLogManager.Gtk";
    platforms = [ "x86_64-linux" ];
  };
})
