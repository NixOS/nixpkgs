{
  fetchurl,
  stdenv,
  lib,
  love,
  lovely-injector,
  curl,
  p7zip,
  copyDesktopItems,
  makeWrapper,
  makeDesktopItem,
  requireFile,
  src ? null,
  withMods ? true,
  withBridgePatch ? true,
  withLinuxPatch ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "balatro";
  version = "1.0.1o";

  src =
    if src != null then
      src
    else
      requireFile {
        name = "Balatro-${finalAttrs.version}.exe";
        url = "https://store.steampowered.com/app/2379780/Balatro/";
        message = ''
          You must own Balatro in order to install it with Nix.  The Steam,
          Google Play, and Xbox PC versions are supported.

          - If you have the Steam version, you can use Balatro.exe.  Find it in

            ~/.local/share/Steam/steamapps/common/Balatro/

            and run

            nix-store --add-fixed sha256 Balatro.exe

          - If you have the Google Play version, you'll need to pull base.apk from
            your device:

            adb shell pm path com.playstack.balatro.android
            adb pull ( path from above )/base.apk ~/Downloads/com.playstack.balatro.android.apk

            and add it to /nix/store:

            nix-prefetch-url file:///home/deck/Downloads/com.playstack.balatro.android.apk

          - If you have the Xbox PC version, you can do the same with Assets.zip.

          If you've used nix-prefetch-url to add it to your store, you'll need to
          pass the resulting path to override:

            balatro.override {
              src = /nix/store/g44bp7ymc7qlkfv5f03b55cgs1wdmkzl-com.playstack.balatro.android.apk;
            }
        '';
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

  buildInputs = [
    love
  ]
  ++ lib.optionals withMods [
    lovely-injector
    curl
  ];

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

    if [ -d "$tmpdir/assets" ]; then
      mv "$tmpdir/assets/"* "$tmpdir/"
      rmdir "$tmpdir/assets"
    elif [ -d "$tmpdir/Assets" ]; then
      mv "$tmpdir/Assets/"* "$tmpdir/"
      rmdir "$tmpdir/Assets"
    fi

    ${lib.optionalString withBridgePatch ''
      cp ${./bridge_detour.lua} $tmpdir/bridge_detour.lua

      for file in main.lua engine/load_manager.lua engine/save_manager.lua; do
        if [ -f "$tmpdir/$file" ]; then
          sed -i '1i require("bridge_detour")' "$tmpdir/$file"
        fi
      done
    ''}

    ${
      let
        patchMarker = "if love.system.getOS() == 'Nintendo Switch' then";
      in
      lib.optionalString withLinuxPatch ''
        substituteInPlace "$tmpdir/globals.lua" --replace-fail \
          "${patchMarker}" \
          "if love.system.getOS() == 'Linux' then
            self.F_SAVE_TIMER = 5
            self.F_DISCORD = true
            self.F_ENGLISH_ONLY = false
        end

        ${patchMarker}"
      ''
    }

    loveFile=game.love
    7z a -tzip $loveFile $tmpdir/*

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 $srcIcon $out/share/icons/hicolor/scalable/apps/balatro.png

    # Packaging the love file into the executable ensures lovely finds the game's name
    # https://github.com/ethangreen-dev/lovely-injector/pull/66#issuecomment-2319615509
    cat ${lib.getExe love} $loveFile > $out/share/Balatro
    chmod +x $out/share/Balatro

    makeWrapper $out/share/Balatro $out/bin/balatro ${lib.optionalString withMods ''
      --prefix LD_PRELOAD : '${lovely-injector}/lib/liblovely.so' \
      --prefix LD_LIBRARY_PATH : '${lib.makeLibraryPath [ curl ]}'
    ''}

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
