{
  lib,
  substitute,

  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,

  gtk3,
  pango,
  cairo,
  atk,
  zlib,
  glib,
  gdk-pixbuf,
  libX11,
  libICE,
  libSM,
  libXi,
  libXcursor,
  libXext,
  libXrandr,
  fontconfig,
  wrapGAppsHook,

  _86Box,
}:
buildDotnetModule {
  pname = "86BoxManagerX";
  version = "1.7.6.0-e";

  src = fetchFromGitHub {
    owner = "RetBox";
    repo = "86BoxManagerX";
    rev = "v1.7.6.0e";
    hash = "sha256-9f9ex1tpZt+Fk1+RnvjfQpoteUeAnUuav75nBBvTFMs=";
  };

  patches = [
    (substitute {
      src = ./fix-paths.patch;
      substitutions = [
        "--replace"
        "@_86Box@"
        _86Box
      ];
    })
  ];

  runtimeDeps = [
    gtk3
    pango
    cairo
    atk
    zlib
    glib
    gdk-pixbuf
    libX11
    libICE
    libSM
    libXi
    libXcursor
    libXext
    libXrandr
    fontconfig # For SkiaSharp
  ];

  nativeBuildInputs = [ wrapGAppsHook ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;
  projectFile = "86BoxManager/86BoxManager.csproj";
  nugetDeps = ./deps.nix;
  executables = [ "86Manager" ];

  meta = with lib; {
    description = "Configuration manager for the 86Box emulator";
    homepage = "https://github.com/RetBox/86BoxManagerX";
    license = licenses.mit;
    mainProgram = "86Manager";
    maintainers = with maintainers; [ jchw ];
    platforms = platforms.unix;
  };
}
