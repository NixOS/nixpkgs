{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  copyDesktopItems,
  wrapGAppsHook3,
  makeDesktopItem,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "plus42";
  version = "1.3.10";

  src = fetchurl {
    url = "https://thomasokken.com/plus42/upstream/plus42-upstream-${version}.tgz";
    hash = "sha256-hXcw3s4Oi8WK1v14PWBIrKZSsAyCOTNa13WhN/3PiLA=";
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
      name = "plus42bin";
      desktopName = "Plus42Bin";
      genericName = "Calculator";
      exec = "plus42bin";
      type = "Application";
      comment = "Software clone of the HP-42S calculator (enhanced version)";
      icon = "plus42";
      categories = [
        "Utility"
        "Calculator"
      ];
    })
    (makeDesktopItem {
      name = "plus42dec";
      desktopName = "Plus42Dec";
      genericName = "Calculator";
      exec = "plus42dec";
      type = "Application";
      comment = "Software clone of the HP-42S calculator (enhanced version)";
      icon = "plus42";
      categories = [
        "Utility"
        "Calculator"
      ];
    })
  ];

  buildPhase = ''
    runHook preBuild

    make -C gtk cleaner
    make --jobs=$NIX_BUILD_CORES -C gtk AUDIO_ALSA=1
    make -C gtk clean
    make --jobs=$NIX_BUILD_CORES -C gtk AUDIO_ALSA=1 BCD_MATH=1

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install --directory $out/bin \
                        $out/share/doc/plus42 \
                        $out/share/plus42/skins \
                        $out/share/icons/hicolor/48x48/apps \
                        $out/share/icons/hicolor/128x128/apps

    install -m755 gtk/plus42dec gtk/plus42bin $out/bin
    install -m644 README $out/share/doc/plus42/README

    install -m644 gtk/icon-48x48.xpm $out/share/icons/hicolor/48x48/apps/plus42.xpm
    install -m644 gtk/icon-128x128.xpm $out/share/icons/hicolor/128x128/apps/plus42.xpm
    install -m644 skins/* $out/share/plus42/skins

    runHook postInstall
  '';

  dontWrapGApps = true;

  postFixup = ''
    wrapProgram $out/bin/plus42dec \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ alsa-lib ]} \
      "''${gappsWrapperArgs[@]}"

    wrapProgram $out/bin/plus42bin \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ alsa-lib ]} \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    homepage = "https://thomasokken.com/plus42/";
    changelog = "https://thomasokken.com/plus42/history.html";
    description = "Software clone of the HP-42S calculator (enhanced version)";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ elfenermarcell ];
    mainProgram = "plus42dec";
    platforms = with lib.platforms; unix;
  };
}
