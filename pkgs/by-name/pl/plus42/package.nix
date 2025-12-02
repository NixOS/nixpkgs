{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  copyDesktopItems,
  wrapGAppsHook3,
  makeDesktopItem,
  pkg-config,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "plus42";
  version = "1.3.12";

  src = fetchurl {
    url = "https://thomasokken.com/plus42/upstream/plus42-upstream-${version}.tgz";
    hash = "sha256-IBXQu1hI0bJZISL9wInAzf2z8zbynXXP15oG/od+MC8=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [ alsa-lib ];

  postPatch = ''
    substituteInPlace gtk/Makefile \
      --replace-fail /bin/ls ls
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

    install -m644 gtk/icon-48x48.png $out/share/icons/hicolor/48x48/apps/plus42.png
    install -m644 gtk/icon-128x128.png $out/share/icons/hicolor/128x128/apps/plus42.png
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

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--url=https://codeberg.org/thomasokken/plus42desktop" ];
  };

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
