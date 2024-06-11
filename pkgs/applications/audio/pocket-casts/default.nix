{ lib
, buildNpmPackage
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, makeWrapper
, electron
}:

buildNpmPackage rec {
  pname = "pocket-casts";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "felicianotech";
    repo = "pocket-casts-desktop-app";
    rev = "v${version}";
    hash = "sha256-d4uVeHy4/91Ki6Wk6GlOt2lcK6U+M7fOryiOYA7q/x4=";
  };

  npmDepsHash = "sha256-rMLUQGcbBJBbxXP67lXp0ww8U2HYM/m1CP2dOw1cCHc=";

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
    maintainers = with maintainers; [ wolfangaukang ];
    mainProgram = "pocket-casts";
    platforms = platforms.linux;
  };
}
