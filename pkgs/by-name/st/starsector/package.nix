{
  lib,
  callPackage,
  linkFarmFromDrvs,
  writeText,
  fetchzip,
  libGL,
  makeWrapper,
  openal,
  openjdk8,
  stdenv,
  xorg,
  copyDesktopItems,
  makeDesktopItem,
  writeShellApplication,
  curl,
  gnugrep,
  common-updater-scripts,

  starsectorMods ? [ ],
}:

assert lib.assertMsg (
  builtins.isList starsectorMods
  && builtins.all (x: x) (
    map (n: lib.isDerivation (builtins.elemAt starsectorMods n)) (
      lib.range 0 ((builtins.length starsectorMods) - 1)
    )
  )
) "The definition for 'starsectorMods' is not of type 'list of derivation'.";

let
  openjdk = openjdk8;

  mkStarsectorMod = lib.recurseIntoAttrs (callPackage ./mods.nix { });
  mergedModPath = linkFarmFromDrvs "mergedModPath" (
    starsectorMods
    ++ [
      (writeText "enabled_mods.json" (
        builtins.toJSON { enabledMods = (map (mod: mod.id) starsectorMods); }
      ))
    ]
  );
in

stdenv.mkDerivation (finalAttrs: {
  pname = "starsector";
  version = "0.97a-RC11";

  src = fetchzip {
    url = "https://f005.backblazeb2.com/file/fractalsoftworks/release/starsector_linux-${finalAttrs.version}.zip";
    hash = "sha256-KT4n0kBocaljD6dTbpr6xcwy6rBBZTFjov9m+jizDW4=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];
  buildInputs = [
    xorg.libXxf86vm
    openal
    libGL
  ];

  dontBuild = true;

  desktopItems = [
    (makeDesktopItem {
      name = "starsector";
      exec = "starsector";
      icon = "starsector";
      comment = finalAttrs.meta.description;
      genericName = "starsector";
      desktopName = "Starsector";
      categories = [ "Game" ];
    })
  ];

  # We need to `cd` into $out in order for `classpath` to pick up correct .jar files.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/starsector
    rm -r jre_linux # remove bundled jre7
    rm starfarer.api.zip
    cp -r ./* $out/share/starsector

    mkdir -p $out/share/icons/hicolor/64x64/apps
    ln -s $out/share/starsector/graphics/ui/s_icon64.png \
      $out/share/icons/hicolor/64x64/apps/starsector.png

    wrapProgram $out/share/starsector/starsector.sh \
      --prefix PATH : ${
        lib.makeBinPath [
          openjdk
          xorg.xrandr
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs} \
      --run 'mkdir -p ''${XDG_DATA_HOME:-~/.local/share}/starsector' \
      --chdir "$out/share/starsector"
    ln -s $out/share/starsector/starsector.sh $out/bin/starsector

    runHook postInstall
  '';

  postPatch =
    # Patch the starsector.sh init script.
    ''
      substituteInPlace starsector.sh \
    ''
    # Starsector tries to run everything with relative paths, which makes it CWD dependent, so we hardcode the relevant store paths here.
    + ''
      --replace-fail "./jre_linux/bin/java" "${openjdk}/bin/java" \
      --replace-fail "./native/linux" "$out/share/starsector/native/linux" \
    ''
    # Set the mods folder to the merged store directory if we're using the mod plugins.
    + lib.optionalString (starsectorMods != [ ]) ''
      --replace-fail "./mods" "${mergedModPath}" \
    ''
    # We also point the mod (if `starsectorMods == [ ]`), screenshot, and save directories to $XDG_DATA_HOME.
    + ''
      --replace-fail "=." "=\''${XDG_DATA_HOME:-\$HOME/.local/share}/starsector" \
    ''
    # Additionally, we add some GC options to improve performance of the game.
    + ''
      --replace-fail "-XX:+CompilerThreadHintNoPreempt" "-XX:+UnlockDiagnosticVMOptions -XX:-BytecodeVerificationRemote -XX:+CMSConcurrentMTEnabled -XX:+DisableExplicitGC" \
    ''
    # Furthermore, we remove the "PermSize" and "MaxPermSize" flags, as they were removed with Java 8.
    + ''
      --replace-quiet " -XX:PermSize=192m -XX:MaxPermSize=192m" "" \
    ''
    # Finally, we pass-through CLI args ($@) to the JVM.
    + ''
      --replace-fail "com.fs.starfarer.StarfarerLauncher" "\"\$@\" com.fs.starfarer.StarfarerLauncher"
    '';

  passthru = {
    updateScript = writeShellApplication {
      name = "starsector-update-script";
      runtimeInputs = [
        curl
        gnugrep
        common-updater-scripts
      ];
      runtimeEnv = {
        inherit (finalAttrs) pname;
      };
      text = builtins.readFile ./update.sh;
    };
    inherit mkStarsectorMod;
  };

  meta = {
    description = "Open-world, single-player space combat, roleplaying, exploration, and economic game";
    longDescription = ''
      Starsector can be extended with third-party modifications from the [Fractal Softworks Forum](https://fractalsoftworks.com/forum/index.php?&board=8.0).
      By default, mods can be imperatively installed in `$HOME/.local/share/starsector/mods`, but you can also override the `starsector` derivation to install mods declaratively, like so:
      ```nix
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          (starsector.override {
            starsectorMods = [
              (starsector.mkStarsectorMod {
                pname = "myFavouriteMod";
                version = "1.0.0";
                url = "https://somefilerepository.example/yourMod/modFile.zip";
                hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
                id = "my_fav_mod";
              })
              # ... more mod derivations.
            ];
          })
        ];
      }
      ```
      This will create a merged store path with the specified mods, and Nix will handle fetching and installing.
      **Note:** as the mods will be stored inside the read-only /nix/store, they will not be able to write files during runtime, which may cause game crashes if they attempt to do anyway.
    '';
    homepage = "https://fractalsoftworks.com";
    downloadPage = finalAttrs.meta.homepage + "/preorder";
    changelog = finalAttrs.meta.homepage + "/blog";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.unfree;
    platforms = lib.systems.inspect.patternLogicalAnd lib.systems.inspect.patterns.isUnix lib.systems.inspect.patterns.isx86_64;
    badPlatforms = lib.systems.inspect.patternLogicalAnd lib.systems.inspect.patterns.isDarwin lib.systems.inspect.patterns.isx86_64;
    maintainers = with lib.maintainers; [
      bbigras
      rafaelrc
      sigmasquadron
    ];
  };
})
