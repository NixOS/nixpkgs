{
  lib,
  stdenv,
  fetchFromCodeberg,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  brux-gdk,
}:

let
  compatibleBrux = brux-gdk.overrideAttrs (old: {
    version = "0-unstable-2026-03-17";
    src = fetchFromCodeberg {
      owner = "KelvinShadewing";
      repo = "brux-gdk";
      rev = "a3e592da1c6c7bae2245c8daee14c6510c771c30";
      hash = "sha256-kvFcS4ZHlqQAfaxMaNr6PYBWMUpXn9sPGXvmobLF1Ac=";
      fetchSubmodules = true;
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "supertux-advance";
  version = "0-unstable-2026-05-06";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "KelvinShadewing";
    repo = "supertux-advance";
    rev = "649fab0437c3fb5e047bfed614a1b740d64cdb8c";
    hash = "sha256-HwBzDg/8YUk+Ch0LXG//lFWAfDh6QdflueMRUSeeP74=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  # Game is pure data (Squirrel scripts, assets)
  buildPhase = "";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/supertux-advance
    cp -r res src game.brx icon.png supertuxadvance.ico lang klc $out/share/supertux-advance/

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      appDir="$out/Applications/SuperTux Advance.app"
      mkdir -p "$appDir/Contents/MacOS"
      mkdir -p "$appDir/Contents/Resources"
      mkdir -p "$out/bin"

      makeWrapper ${lib.getExe compatibleBrux} "$appDir/Contents/MacOS/SuperTux Advance" \
        --chdir "$out/share/supertux-advance" \
        --add-flags "game.brx"

      ln -s "$appDir/Contents/MacOS/SuperTux Advance" "$out/bin/supertux-advance"
      cp icon.png "$appDir/Contents/Resources/"
    ''}

    ${lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      makeWrapper ${lib.getExe compatibleBrux} $out/bin/supertux-advance \
        --chdir $out/share/supertux-advance \
        --add-flags "game.brx"
    ''}

    install -Dm644 icon.png $out/share/icons/hicolor/128x128/apps/supertux-advance.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "supertux-advance";
      exec = "supertux-advance";
      icon = "supertux-advance";
      desktopName = "SuperTux Advance";
      comment = "2D pixel platformer starring Tux the Penguin and other FOSS mascots";
      categories = [
        "Game"
      ];
      type = "Application";
    })
  ];

  meta = {
    description = "2D pixel platformer starring Tux the Penguin and other FOSS mascots";
    homepage = "https://codeberg.org/KelvinShadewing/supertux-advance";
    changelog = "https://codeberg.org/KelvinShadewing/supertux-advance/releases";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "supertux-advance";
  };
})
