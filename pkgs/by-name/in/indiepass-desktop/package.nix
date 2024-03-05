{ lib
, buildNpmPackage
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, makeWrapper
, electron
}:

buildNpmPackage rec {
  pname = "indiepass-desktop";
  version = "1.4.0-unstable-2023-05-19";

  src = fetchFromGitHub {
    owner = "indiepass";
    repo = "indiepass-desktop";
    rev = "751660324d6bfc6f95af08bf9bc92e892841f2b2";
    hash = "sha256-cQqL8eNb23NFMWrK9xh6bZcr0EoYbyJiid+xXQRPqMk=";
  };

  npmDepsHash = "sha256-gp77eDxturBib0JRNVNSd+nDxQyVTJVKEj4ydB7eICE=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  dontNpmBuild = true;

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "indiepass";
      icon = "indiepass";
      comment = meta.description;
      desktopName = "Indiepass";
      genericName = "Feed Reader";
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  postInstall = ''
    install -Dm 644 $out/lib/node_modules/indiepass/images/icon.png $out/share/pixmaps/indiepass.png

    makeWrapper ${electron}/bin/electron $out/bin/indiepass \
      --add-flags $out/lib/node_modules/indiepass/main.js
  '';

  meta = with lib; {
    description = "IndieWeb app with extensions for sharing to/reading from micropub endpoints";
    homepage = "https://github.com/IndiePass/indiepass-desktop";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
    mainProgram = "indiepass";
    platforms = [ "x86_64-linux" ];
  };
}
