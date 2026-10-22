{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  wrapGAppsHook3,
  copyDesktopItems,
  gtk3,
  libnotify,
  makeDesktopItem,
  stdenv,
}:

buildDotnetModule rec {
  pname = "pablodraw";
  version = "3.1.14-beta";

  src = fetchFromGitHub {
    owner = "cwensley";
    repo = "pablodraw";
    tag = version;
    hash = "sha256-p2YeWC3ZZOI5zDpgDmEX3C5ByAAjLxJ0CqFAqKeoJ0Q=";
  };

  projectFile = "Source/PabloDraw/PabloDraw.csproj";

  executables = [ "PabloDraw" ];

  dotnet-sdk = dotnetCorePackages.sdk_9_0;

  nugetDeps = ./deps.json;

  dotnetFlags = [
    "-p:EnableCompressionInSingleFile=false"
    "-p:TargetFrameworks=net9.0"
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    copyDesktopItems
  ];

  runtimeDeps = [
    gtk3
    libnotify
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "PabloDraw";
      exec = "PabloDraw";
      comment = "An Ansi/Ascii text and RIPscrip vector graphic art editor/viewer";
      type = "Application";
      icon = "pablodraw";
      desktopName = "PabloDraw";
      terminal = false;
      categories = [ "Graphics" ];
    })
  ];

  postInstall = ''
    install -Dm644 Assets/PabloDraw-512.png $out/share/icons/hicolor/512x512/apps/pablodraw.png
    install -Dm644 Assets/PabloDraw-64.png $out/share/icons/hicolor/64x64/apps/pablodraw.png
  '';

  meta = {
    description = "Ansi/Ascii text and RIPscrip vector graphic art editor/viewer with multi-user capabilities";
    homepage = "https://picoe.ca/products/pablodraw";
    license = lib.licenses.mit;
    mainProgram = "PabloDraw";
    maintainers = with lib.maintainers; [
      aleksana
      kip93
    ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # Eto.Platform.Mac64 not found in nugetSource
  };
}
