{ lib
, buildDotnetModule
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, graphicsmagick
, dotnetCorePackages
, gtk3
, libnotify
}:

buildDotnetModule rec {
  pname = "pablodraw";
  version = "3.3.13-beta";

  src = fetchFromGitHub {
    owner = "cwensley";
    repo = "pablodraw";
    rev = version;
    hash = "sha256-PsCFiNcWYh6Bsf5Ihi3IoYyv66xUT1cRBKkx+K5gB/M=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;

  projectFile = "Source/PabloDraw/PabloDraw.csproj";
  nugetDeps = ./deps.nix;
  dotnetFlags = [ "-p:PublishSingleFile=false" ];

  nativeBuildInputs = [
    copyDesktopItems
    graphicsmagick
  ];
  runtimeDeps = [
    gtk3
    libnotify
  ];

  postFixup = ''
    mkdir -p $out/share/icons/hicolor/128x128/apps
    gm convert $src/Source/PabloDraw/PabloDraw.ico $out/share/icons/hicolor/128x128/apps/${meta.mainProgram}.png
  '';

  desktopItems = makeDesktopItem {
    name = meta.mainProgram;
    exec = meta.mainProgram;
    icon = meta.mainProgram;
    desktopName = meta.mainProgram;
    comment = meta.description;
    type = "Application";
    categories = [ "Graphics" ];
  };

  meta = with lib; {
    mainProgram = "PabloDraw";
    description = "An Ansi/Ascii text and RIPscrip vector graphic art editor/viewer with multi-user capabilities.";
    homepage = "https://picoe.ca/products/pablodraw";
    license = licenses.mit;
    maintainers = with maintainers; [ kip93 ];
  };
}
