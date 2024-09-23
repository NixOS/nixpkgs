{
  lib,
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
}:

let
  openjdk = openjdk8;
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
    # We also point the mod, screenshot, and save directories to $XDG_DATA_HOME.
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
  };

  meta = {
    description = "Open-world, single-player space combat, roleplaying, exploration, and economic game";
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
