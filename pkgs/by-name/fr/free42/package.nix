{
  lib,
  stdenv,
  fetchFromGitea,
  alsa-lib,
  copyDesktopItems,
  wrapGAppsHook3,
  makeDesktopItem,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "free42";
  version = "3.3.8";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "thomasokken";
    repo = "free42";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L6WZM5/+ujM6hv85ppt9YiqHLkd0vYFx3nFVcJwzEBM=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [ alsa-lib ];

  postPatch = ''
    sed -i -e "s|/bin/ls|ls|" gtk/Makefile
  '';

  dontConfigure = true;

  desktopItems = [
    (makeDesktopItem {
      name = "com.thomasokken.free42bin";
      desktopName = "Free42Bin";
      genericName = "Calculator";
      exec = "free42bin";
      type = "Application";
      comment = "A software clone of HP-42S Calculator";
      icon = "free42";
      categories = [
        "Utility"
        "Calculator"
      ];
    })
    (makeDesktopItem {
      name = "com.thomasokken.free42dec";
      desktopName = "Free42Dec";
      genericName = "Calculator";
      exec = "free42dec";
      type = "Application";
      comment = "A software clone of HP-42S Calculator";
      icon = "free42";
      categories = [
        "Utility"
        "Calculator"
      ];
    })
  ];

  buildPhase = ''
    runHook preBuild

    make -C gtk cleaner
    make --jobs=$NIX_BUILD_CORES -C gtk
    make -C gtk clean
    make --jobs=$NIX_BUILD_CORES -C gtk BCD_MATH=1

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install --directory $out/bin \
                        $out/share/doc/free42 \
                        $out/share/free42/skins \
                        $out/share/icons/hicolor/48x48/apps \
                        $out/share/icons/hicolor/128x128/apps

    install -m755 gtk/free42dec gtk/free42bin $out/bin
    install -m644 README $out/share/doc/free42/README

    install -m644 gtk/icon-48x48.xpm $out/share/icons/hicolor/48x48/apps/free42.xpm
    install -m644 gtk/icon-128x128.xpm $out/share/icons/hicolor/128x128/apps/free42.xpm
    install -m644 skins/* $out/share/free42/skins

    runHook postInstall
  '';

  meta = {
    homepage = "https://thomasokken.com/free42/";
    changelog = "https://thomasokken.com/free42/history.html";
    description = "Software clone of HP-42S Calculator";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "free42dec";
    platforms = with lib.platforms; unix;
  };
})
