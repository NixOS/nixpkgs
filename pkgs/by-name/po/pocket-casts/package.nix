{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  electron,
}:

buildNpmPackage rec {
  pname = "pocket-casts";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "felicianotech";
    repo = "pocket-casts-desktop-app";
    rev = "v${version}";
    hash = "sha256-PwM9B2Qx4TxlcahQM/KEBTzWKc4cNrleDEYKg0m8bVE=";
  };

  npmDepsHash = "sha256-WPuXTcHCKrwepITGtZFCIwylVAdYlI3cNsuhqx1AEYI=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  dontNpmBuild = true;

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Pocket Casts";
      genericName = "Podcasts Listener";
      exec = "pocket-casts";
      icon = "pocket-casts";
      comment = meta.description;
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  postInstall = ''
    install -Dm644 $out/lib/node_modules/pocket-casts/icon.png $out/share/pixmaps/pocket-casts.png
    install -Dm644 $out/lib/node_modules/pocket-casts/icon-x360.png $out/share/pixmaps/pocket-casts-x360.png

    makeWrapper ${electron}/bin/electron $out/bin/pocket-casts \
      --add-flags $out/lib/node_modules/pocket-casts/main.js
  '';

  meta = with lib; {
    description = "Pocket Casts webapp, packaged for the Linux Desktop";
    homepage = "https://github.com/felicianotech/pocket-casts-desktop-app";
    license = licenses.mit;
    maintainers = with maintainers; [ yayayayaka ];
    mainProgram = "pocket-casts";
    platforms = platforms.linux;
  };
}
