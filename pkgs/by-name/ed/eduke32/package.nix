{
  lib,
  stdenv,
  fetchFromGitLab,
  makeWrapper,
  pkg-config,
  nasm,
  makeDesktopItem,
  copyDesktopItems,
  alsa-lib,
  flac,
  libvorbis,
  libvpx,
  libGL,
  SDL2,
  SDL2_mixer,
  xorg,
  graphicsmagick,
  unstableGitUpdater,
}:

let
  wrapper = "eduke32-wrapper";
  swWrapper = "voidsw-wrapper";
  furyWrapper = "fury-wrapper";

in
stdenv.mkDerivation (finalAttrs: {
  pname = "eduke32";
  version = "0-unstable-2025-07-04";

  src = fetchFromGitLab {
    domain = "voidpoint.io";
    owner = "terminx";
    repo = "eduke32";
    rev = "388752735c68456b89d8acffcb836e6802308007";
    hash = "sha256-QQ0qKY/ZK0SwxMkZ76792w7iCO+ZpGWGJutHJW1e5+Q=";
    deepClone = true;
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git rev-list --count HEAD > VC_REV
      rm -rf .git
    '';
  };

  patches = [
    # gdk-pixbuf-csource no longer supports bmp so convert to png
    # patch GNUMakefile to use graphicsmagick to convert bmp -> png
    ./convert-bmp-to-png.diff
  ];

  buildInputs =
    [
      flac
      libvorbis
      libvpx
      SDL2
      SDL2_mixer
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      libGL
      xorg.libX11
    ];

  nativeBuildInputs =
    [
      makeWrapper
      pkg-config
      copyDesktopItems
      graphicsmagick
    ]
    ++ lib.optionals (stdenv.hostPlatform.system == "i686-linux") [
      nasm
    ];

  postPatch =
    ''
      substituteInPlace source/imgui/src/imgui_impl_sdl2.cpp \
        --replace-fail '#include <SDL.h>' '#include <SDL2/SDL.h>' \
        --replace-fail '#include <SDL_syswm.h>' '#include <SDL2/SDL_syswm.h>' \
        --replace-fail '#include <SDL_vulkan.h>' '#include <SDL2/SDL_vulkan.h>'
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      for f in glad.c glad_wgl.c ; do
        substituteInPlace source/glad/src/$f \
          --replace-fail libGL.so ${libGL}/lib/libGL.so
      done
    '';

  makeFlags = [
    "SDLCONFIG=${SDL2}/bin/sdl2-config"
    "VC_HASH=${lib.substring 0 9 finalAttrs.src.rev}"
    "VC_BRANCH=master"
    "HAVE_GTK2=0"
  ];

  buildFlags = [
    "duke3d"
    "sw"
  ];

  preConfigure = ''
    appendToVar makeFlags "VC_REV=$(cat VC_REV)"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "eduke32";
      icon = "eduke32";
      exec = "${wrapper}";
      comment = "Duke Nukem 3D port";
      desktopName = "Enhanced Duke Nukem 3D";
      genericName = "Duke Nukem 3D port";
      categories = [ "Game" ];
    })
    (makeDesktopItem {
      name = "voidsw";
      icon = "voidsw";
      exec = "${swWrapper}";
      comment = "Shadow Warrior eduke32 source port";
      desktopName = "VoidSW";
      genericName = "Shadow Warrior source port";
      categories = [ "Game" ];
    })
    (makeDesktopItem {
      name = "fury";
      icon = "fury";
      exec = "${furyWrapper}";
      comment = "Ion Fury eduke32 source port";
      desktopName = "Ion Fury";
      genericName = "Ion Fury source port";
      categories = [ "Game" ];
    })
  ];

  enableParallelBuilding = true;

  installPhase =
    ''
      runHook preInstall

      install -Dm755 -t $out/bin eduke32 mapster32 voidsw wangulator
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      makeWrapper $out/bin/eduke32 $out/bin/${wrapper} \
        --set-default EDUKE32_DATA_DIR /var/lib/games/eduke32 \
        --add-flags '-j"$EDUKE32_DATA_DIR"' \
        --add-flags '-gamegrp DUKE3D.GRP'
      makeWrapper $out/bin/voidsw $out/bin/${swWrapper} \
        --set-default EDUKE32_DATA_DIR /var/lib/games/eduke32 \
        --add-flags '-j"$EDUKE32_DATA_DIR"'
      makeWrapper $out/bin/eduke32 $out/bin/${furyWrapper} \
        --set-default EDUKE32_DATA_DIR /var/lib/games/eduke32 \
        --add-flags '-j"$EDUKE32_DATA_DIR"' \
        --add-flags '-gamegrp FURY.GRP'
      mkdir -p $out/share/icons/hicolor/scalable/apps
      gm convert "./source/duke3d/rsrc/game_icon.ico[10]" $out/share/icons/hicolor/scalable/apps/eduke32.png
      install -Dm644 ./source/sw/rsrc/game_icon.svg $out/share/icons/hicolor/scalable/apps/voidsw.svg
      gm convert "./source/duke3d/rsrc/fury/game_icon.ico[4]" $out/share/icons/hicolor/scalable/apps/fury.png
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications/EDuke32.app/Contents/MacOS
      mkdir -p $out/Applications/Mapster32.app/Contents/MacOS
      mkdir -p $out/Applications/VoidSW.app/Contents/MacOS
      mkdir -p $out/Applications/Wangulator.app/Contents/MacOS

      cp -r platform/Apple/bundles/EDuke32.app/* $out/Applications/EDuke32.app/
      cp -r platform/Apple/bundles/Mapster32.app/* $out/Applications/Mapster32.app/
      cp -r platform/Apple/bundles/VoidSW.app/* $out/Applications/VoidSW.app/
      cp -r platform/Apple/bundles/Wangulator.app/* $out/Applications/Wangulator.app/

      ln -sf $out/bin/eduke32 $out/Applications/EDuke32.app/Contents/MacOS/eduke32
      ln -sf $out/bin/mapster32 $out/Applications/Mapster32.app/Contents/MacOS/mapster32
      ln -sf $out/bin/voidsw $out/Applications/VoidSW.app/Contents/MacOS/voidsw
      ln -sf $out/bin/wangulator $out/Applications/Wangulator.app/Contents/MacOS/wangulator
    ''
    + ''
      runHook postInstall
    '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Enhanched port of Duke Nukem 3D for various platforms";
    homepage = "http://eduke32.com";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [
      qubitnano
      sander
    ];
    platforms = lib.platforms.all;
  };
})
