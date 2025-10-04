{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  electron_36,
}:
let
  electron = electron_36;
in
buildNpmPackage rec {
  pname = "pocket-casts";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "felicianotech";
    repo = "pocket-casts-desktop-app";
    rev = "v${version}";
    hash = "sha256-LB0SOAcgCZuNKOWhL9m4cDF9q+voVd+2OYVeKTq7OB0=";
  };

  npmDepsHash = "sha256-i8IKH3sacYWLa2GtcJSoWCy5eV9vC79dP9WVN2Iy7DE=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  dontNpmBuild = true;

  makeCacheWritable = true;

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
    install -Dm444 $out/lib/node_modules/pocket-casts/img/icon-x512.png $out/share/icons/hicolor/512x512/apps/pocket-casts.png
    install -Dm444 $out/lib/node_modules/pocket-casts/img/icon-x360.png $out/share/icons/hicolor/360x360/apps/pocket-casts.png

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
