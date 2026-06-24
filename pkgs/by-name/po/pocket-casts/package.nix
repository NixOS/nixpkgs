{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  electron_40,
}:
let
  electron = electron_40;
in
buildNpmPackage rec {
  pname = "pocket-casts";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "felicianotech";
    repo = "pocket-casts-desktop-app";
    rev = "v${version}";
    hash = "sha256-v5R83h+AHpGbh3pXehalEjuD+s5grAowgGfvr7FsJKU=";
  };

  npmDepsHash = "sha256-335PYsGbYwYtMoLi1UkwdX3mPA0DOs79Lm1Kg7V83ZM=";

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

  meta = {
    description = "Pocket Casts webapp, packaged for the Linux Desktop";
    homepage = "https://github.com/felicianotech/pocket-casts-desktop-app";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yayayayaka ];
    mainProgram = "pocket-casts";
    platforms = lib.platforms.linux;
  };
}
