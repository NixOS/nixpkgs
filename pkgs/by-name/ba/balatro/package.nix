{
  fetchurl,
  stdenv,
  lib,
  love,
  lovely-injector,
  p7zip,
  copyDesktopItems,
  makeWrapper,
  makeDesktopItem,
  requireFile,
  withMods ? true,
  withLinuxPatch ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "balatro";
  version = "1.0.1o";

  src = requireFile {
    name = "Balatro-${finalAttrs.version}.exe";
    url = "https://store.steampowered.com/app/2379780/Balatro/";
    # Use `nix --extra-experimental-features nix-command hash file --sri --type sha256` to get the correct hash
    hash = "sha256-DXX+FkrM8zEnNNSzesmHiN0V8Ljk+buLf5DE5Z3pP0c=";
  };

  srcIcon = fetchurl {
    name = "balatro.png";
    url = "https://play-lh.googleusercontent.com/RSPv_SMlA3Lun8VHaJD7xCBQg29eCJR9sNJtZNJGlybVs8byYVLz4WnohrbLScC9srg";
    hash = "sha256-GoStvXBYI8x5b8T0wwH5D5C3Kahu0ssCyOM8MoLxy8Q=";
  };

  nativeBuildInputs = [
    p7zip
    copyDesktopItems
    makeWrapper
  ];
  buildInputs = [ love ] ++ lib.optional withMods lovely-injector;
  dontUnpack = true;
  desktopItems = [
    (makeDesktopItem {
      name = "balatro";
      desktopName = "Balatro";
      exec = "balatro";
      keywords = [ "Game" ];
      categories = [ "Game" ];
      icon = "balatro";
    })
  ];
  buildPhase = ''
    runHook preBuild
    tmpdir=$(mktemp -d)
    7z x ${finalAttrs.src} -o$tmpdir -y
    ${if withLinuxPatch then "patch $tmpdir/globals.lua -i ${./globals.patch}" else ""}
    patchedExe=$(mktemp -u).zip
    7z a $patchedExe $tmpdir/*
    runHook postBuild
  '';

  # The `cat` bit is a hack suggested by whitelje (https://github.com/ethangreen-dev/lovely-injector/pull/66#issuecomment-2319615509)
  # to make it so that lovely will pick up Balatro as the game name. The `LD_PRELOAD` bit is used to load lovely and it is the
  # 'official' way of doing it.
  installPhase = ''
    runHook preInstall
    install -Dm644 $srcIcon $out/share/icons/hicolor/scalable/apps/balatro.png

    cat ${lib.getExe love} $patchedExe > $out/share/Balatro
    chmod +x $out/share/Balatro

    makeWrapper $out/share/Balatro $out/bin/balatro ${lib.optionalString withMods "--prefix LD_PRELOAD : '${lovely-injector}/lib/liblovely.so'"}
    runHook postInstall
  '';

  meta = {
    description = "Poker roguelike";
    longDescription = ''
      Balatro is a hypnotically satisfying deckbuilder where you play illegal poker hands,
      discover game-changing jokers, and trigger adrenaline-pumping, outrageous combos.
    '';
    license = lib.licenses.unfree;
    homepage = "https://store.steampowered.com/app/2379780/Balatro/";
    maintainers = with lib.maintainers; [
      antipatico
      appsforartists
    ];
    platforms = love.meta.platforms;
    mainProgram = "balatro";
  };
})
