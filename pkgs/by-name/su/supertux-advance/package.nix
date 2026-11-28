{
  lib,
  stdenv,
  fetchFromCodeberg,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  brux-gdk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "supertux-advance";
  version = "0.2.1-unstable-2026-09-28";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "KelvinShadewing";
    repo = "supertux-advance";
    rev = "2f691103c7708dec44fa78436ebad834481b7cd1";
    hash = "sha256-UkfpBA/G1GZYeh56MG/feDqTTvwJhmUdeVWF0fyT4xg=";
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

      install -Dm644 ${./Info.plist} "$appDir/Contents/Info.plist"
      substituteInPlace "$appDir/Contents/Info.plist" \
        --replace-fail '@VERSION@' "${finalAttrs.version}"

      makeWrapper ${lib.getExe brux-gdk} "$appDir/Contents/MacOS/SuperTux Advance" \
        --chdir "$out/share/supertux-advance" \
        --add-flags "game.brx"

      ln -s "$appDir/Contents/MacOS/SuperTux Advance" "$out/bin/supertux-advance"
      cp icon.png "$appDir/Contents/Resources/"
    ''}

    ${lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      makeWrapper ${lib.getExe brux-gdk} $out/bin/supertux-advance \
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
