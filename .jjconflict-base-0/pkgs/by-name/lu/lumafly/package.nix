{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  zlib,
  icu,
  openssl,
  icoutils,
  copyDesktopItems,
  makeDesktopItem,
}:
buildDotnetModule rec {
  pname = "lumafly";
  version = "3.3.0.0";

  src = fetchFromGitHub {
    owner = "TheMulhima";
    repo = "lumafly";
    rev = "v${version}";
    hash = "sha256-GVPMAwxbq9XlKjMKd9G5yUol42f+6lSyHukN7NMCVDA=";
  };

  projectFile = "Lumafly/Lumafly.csproj";

  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_7_0;

  selfContainedBuild = true;

  runtimeDeps = [
    zlib
    icu
    openssl
  ];

  nativeBuildInputs = [
    icoutils
    copyDesktopItems
  ];

  postFixup = ''
    # Icon for the desktop file
    icotool -x $src/Lumafly/Assets/Lumafly.ico
    install -D Lumafly_1_32x32x32.png $out/share/icons/hicolor/32x32/apps/lumafly.png
  '';

  desktopItems = [(makeDesktopItem {
    desktopName = "Lumafly";
    name = "lumafly";
    exec = "Lumafly";
    icon = "lumafly";
    comment = meta.description;
    type = "Application";
    categories = [ "Game" ];
  })];

  meta = {
    description = "A cross platform mod manager for Hollow Knight written in Avalonia";
    homepage = "https://themulhima.github.io/Lumafly/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "Lumafly";
    maintainers = with lib.maintainers; [ rohanssrao ];
    platforms = lib.platforms.linux;
  };
}
