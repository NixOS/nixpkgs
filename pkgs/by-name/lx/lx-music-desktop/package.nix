{
  lib,
  stdenv,
  buildNpmPackage,

  fetchFromGitHub,
  replaceVars,

  copyDesktopItems,
  makeWrapper,
  makeDesktopItem,

  electron_42,
  commandLineArgs ? "",
}:

let
  electron = electron_42;
in
buildNpmPackage (finalAttrs: {
  pname = "lx-music-desktop";
  version = "2.12.4";

  src = fetchFromGitHub {
    owner = "lyswhut";
    repo = "lx-music-desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sjdWDpObF+AxPLommw1biJU8OgTALYLEjJDV2yBiCPg=";
  };

  desktopItems = [
    (makeDesktopItem {
      categories = [
        "Utility"
        "AudioVideo"
        "Audio"
        "Player"
        "Music"
      ];
      desktopName = "LX Music Desktop";
      exec = "lx-music-desktop";
      genericName = "Music Player";
      icon = "lx-music-desktop";
      mimeTypes = [ "x-scheme-handler/lxmusic" ];
      name = "lx-music-desktop";
      startupNotify = false;
      startupWMClass = "lx-music-desktop";
      terminal = false;
      type = "Application";
    })
  ];

  patches = [
    # set electron version and dist dir
    # disable before-pack: it would copy prebuilt libraries
    (replaceVars ./electron-builder.patch {
      electron_version = electron.version;
    })
  ];

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  npmDepsHash = "sha256-A7tR1mZ9TlGj+srPb6ZrJcCPbafT4e51XDexE76jPXc=";

  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # we haven't set up npm_config_nodedir at this point
  # and electron-rebuild will rebuild the native libs later anyway
  npmFlags = [ "--ignore-scripts" ];

  preBuild = ''
    # delete prebuilt libs
    rm -r build-config/lib
    rm -r node_modules/better-sqlite3/prebuilds

    # prevent copying previously deleted libs to node_modules
    substituteInPlace build-config/postinstall.js \
      --replace-fail 'copyLib()' ""

    # don't spam the build logs
    substituteInPlace build-config/pack.js \
      --replace-fail 'new Spinnies({' 'new Spinnies({disableSpins:true,'

    # this directory is configured to be used in the patch
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    export npm_config_nodedir=${electron.headers}
    export npm_config_build_from_source="true"

    npm rebuild --no-progress --verbose
  '';

  npmBuildScript = "pack:dir";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/opt/lx-music-desktop"
    cp -r build/*-unpacked/{locales,resources{,.pak}} "$out/opt/lx-music-desktop"
    rm "$out/opt/lx-music-desktop/resources/app-update.yml"

    for size in 16 32 48 64 128 256 512; do
      install -D -m 444 resources/icons/"$size"x"$size".png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/lx-music-desktop.png
    done

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${lib.getExe electron} $out/bin/lx-music-desktop \
      --add-flags $out/opt/lx-music-desktop/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}
  '';

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Music software based on Electron and Vue";
    longDescription = ''
      Some functionalities (e.g. lyrics window) are broken when lx-music-desktop
      runs using a Wayland ozone platform due to Electron's lack of support
      for Wayland. If you do need these features, please consider unsetting
      `NIXOS_OZONE_WL` and passing `--ozone-platform=x11` from the command line
      to restore the expected behavior.
    '';
    homepage = "https://github.com/lyswhut/lx-music-desktop";
    changelog = "https://github.com/lyswhut/lx-music-desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = electron.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "lx-music-desktop";
    maintainers = with lib.maintainers; [ starryreverie ];
  };
})
