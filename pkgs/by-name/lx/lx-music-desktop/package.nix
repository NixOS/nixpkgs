{
  lib,
  stdenv,
  buildNpmPackage,

  fetchFromGitHub,
  replaceVars,

  copyDesktopItems,
  makeWrapper,
  makeDesktopItem,

  electron_40,
  nodejs_22,
  commandLineArgs ? "",
}:

let
  electron = electron_40;
in
buildNpmPackage (finalAttrs: {
  pname = "lx-music-desktop";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "lyswhut";
    repo = "lx-music-desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g4QVpymzoRKIq70aRLXGFmUmIpSiXIZThrp8fumBKTQ=";
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
    ./electron-version.patch
  ];

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  # Npm 11 (nodejs 24) can't resolve all dependencies from the prefetched cache.
  nodejs = nodejs_22;

  npmDepsHash = "sha256-BmrY7IXx6Z+sBAemYnOZUBMyLInENMOB6fh/4LoV80w=";

  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # we haven't set up npm_config_nodedir at this point
  # and electron-rebuild will rebuild the native libs later anyway
  npmFlags = [ "--ignore-scripts" ];

  preBuild = ''
    # delete prebuilt libs
    rm -r build-config/lib

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
    homepage = "https://github.com/lyswhut/lx-music-desktop";
    changelog = "https://github.com/lyswhut/lx-music-desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = electron.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "lx-music-desktop";
    maintainers = with lib.maintainers; [ starryreverie ];
  };
})
