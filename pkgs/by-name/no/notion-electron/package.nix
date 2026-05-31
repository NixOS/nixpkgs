{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  electron,
  imagemagick,
}:

buildNpmPackage rec {
  pname = "notion-electron";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "anechunaev";
    repo = "notion-electron";
    rev = "v${version}";
    hash = "sha256-pFPGkE2XwlBEbitl0OatfQAht1TmcErnVMZCFYjwZ8I=";
  };

  npmDepsHash = "sha256-EMY7Y95bp12+jLn5Wv6x134utA0LFqldP/d8zHrs/RI=";

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    imagemagick
  ];

  npmFlags = [ "--ignore-scripts" ];

  dontNpmBuild = true;

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "notion-electron %U";
      icon = "notion-electron";
      desktopName = "Notion";
      comment = "Notion Electron Wrapper";
      type = "Application";
      categories = [ "Office" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/notion-electron
    mkdir -p $out/bin
    mkdir -p $out/share/icons/hicolor/256x256/apps

    # Copy the code
    cp -r . $out/lib/notion-electron/

    # Convert the SVG logo
    magick assets/logo.svg -resize 256x256 $out/share/icons/hicolor/256x256/apps/notion-electron.png

    # Create the wrapper
    makeWrapper ${electron}/bin/electron $out/bin/notion-electron \
      --add-flags "--class=notion-electron" \
      --add-flags "$out/lib/notion-electron"

    runHook postInstall
  '';

  meta = {
    description = "Enhanced Notion Desktop client for Linux";
    homepage = "https://github.com/anechunaev/notion-electron";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Mowerick ];
    platforms = lib.platforms.linux;
    mainProgram = "notion-electron";
  };
}
