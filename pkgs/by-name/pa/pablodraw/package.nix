{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, wrapGAppsHook3
, copyDesktopItems
, gtk3
, libnotify
, makeDesktopItem
, stdenv
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

  postPatch = ''
    substituteInPlace ${projectFile} \
      --replace-warn '<EnableCompressionInSingleFile>True</EnableCompressionInSingleFile>' ""
  '';

  projectFile = "Source/PabloDraw/PabloDraw.csproj";

  executables = [ "PabloDraw" ];

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;

  nugetDeps = ./deps.nix;

  nativeBuildInputs = [ wrapGAppsHook3 copyDesktopItems ];

  runtimeDeps = [ gtk3 libnotify ];

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

  meta = with lib; {
    description = "An Ansi/Ascii text and RIPscrip vector graphic art editor/viewer with multi-user capabilities";
    homepage = "https://picoe.ca/products/pablodraw";
    license = licenses.mit;
    mainProgram = "PabloDraw";
    maintainers = with maintainers; [ aleksana kip93 ];
    platforms = platforms.all;
    broken = stdenv.isDarwin; # Eto.Platform.Mac64 not found in nugetSource
  };
}
