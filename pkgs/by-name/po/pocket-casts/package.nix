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
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "felicianotech";
    repo = "pocket-casts-desktop-app";
    rev = "v${version}";
    hash = "sha256-qXwLnAp8GxOBnPy5uM/Y4dKlALRLo9Hs2p8/WSJcAyE=";
  };

  npmDepsHash = "sha256-HU+jfp+Rmw78wTSA0m9Q6EW6+bw84+MEnnSaPnKqqIo=";

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
