{
  lib,
  stdenv,
  buildNpmPackage,

  fetchFromGitHub,
  replaceVars,

  makeWrapper,

  electron_36,
  commandLineArgs ? "",
}:

let
  electron = electron_36;
in
buildNpmPackage rec {
  pname = "lx-music-desktop";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "lyswhut";
    repo = "lx-music-desktop";
    tag = "v${version}";
    hash = "sha256-NMj8rb5PAejT1HCE5nxi2+SS9lFUVdLEqN0id23QjVc=";
  };

  patches = [
    # set electron version and dist dir
    # disable before-pack: it would copy prebuilt libraries
    (replaceVars ./electron-builder.patch {
      electron_version = electron.version;
    })
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  npmDepsHash = "sha256-cA9NdHe3lEg8twMLWoeomWgobidZ34TKwdC5rDezZ5g=";

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
    changelog = "https://github.com/lyswhut/lx-music-desktop/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = electron.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "lx-music-desktop";
    maintainers = with lib.maintainers; [ ];
  };
}
