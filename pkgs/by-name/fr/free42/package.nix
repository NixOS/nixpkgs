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
  pname = "free42";
  version = "3.3.10";

  src = fetchurl {
    url = "https://thomasokken.com/free42/upstream/free42-nologo-${version}.tgz";
    hash = "sha256-Vh+Sh3oX1ICy0R6R4zu9Df2+ba2mM33qHtifINNpn7Y=";
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
      name = "free42bin";
      desktopName = "Free42Bin";
      genericName = "Calculator";
      exec = "free42bin";
      type = "Application";
      comment = "Software clone of the HP-42S calculator";
      icon = "free42";
      categories = [
        "Utility"
        "Calculator"
      ];
    })
    (makeDesktopItem {
      name = "free42dec";
      desktopName = "Free42Dec";
      genericName = "Calculator";
      exec = "free42dec";
      type = "Application";
      comment = "Software clone of the HP-42S calculator";
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
    make --jobs=$NIX_BUILD_CORES -C gtk AUDIO_ALSA=1
    make -C gtk clean
    make --jobs=$NIX_BUILD_CORES -C gtk AUDIO_ALSA=1 BCD_MATH=1

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

    install -m644 gtk/icon-48x48.png $out/share/icons/hicolor/48x48/apps/free42.png
    install -m644 gtk/icon-128x128.png $out/share/icons/hicolor/128x128/apps/free42.png
    install -m644 skins/* $out/share/free42/skins

    runHook postInstall
  '';

  dontWrapGApps = true;

  postFixup = ''
    wrapProgram $out/bin/free42dec \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ alsa-lib ]} \
      "''${gappsWrapperArgs[@]}"

    wrapProgram $out/bin/free42bin \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ alsa-lib ]} \
      "''${gappsWrapperArgs[@]}"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--url=https://codeberg.org/thomasokken/free42" ];
  };

  meta = {
    homepage = "https://thomasokken.com/free42/";
    changelog = "https://thomasokken.com/free42/history.html";
    description = "Software clone of the HP-42S calculator";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ elfenermarcell ];
    mainProgram = "free42dec";
    platforms = with lib.platforms; unix;
  };
}
