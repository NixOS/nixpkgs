{
  lib,
  stdenv,
  buildNpmPackage,

  fetchFromGitHub,
  replaceVars,

  makeWrapper,

  electron_34,
  commandLineArgs ? "",
}:

let
  # if we want to use later electron, we'll need to bump the `node-abi` npm package version
  electron = electron_34;
in
buildNpmPackage rec {
  pname = "lx-music-desktop";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "lyswhut";
    repo = "lx-music-desktop";
    tag = "v${version}";
    hash = "sha256-8IzQEGdaeoBbCsZSPhVowipeBr4YHGm/G28qGHtCY/s=";
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

  npmDepsHash = "sha256-awD8gu1AnhUn5uT/dITXjMVWNAwABAmcEVZOKukbWrI=";

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

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Music software based on Electron and Vue";
    homepage = "https://github.com/lyswhut/lx-music-desktop";
    changelog = "https://github.com/lyswhut/lx-music-desktop/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = electron.meta.platforms;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "lx-music-desktop";
    maintainers = with maintainers; [ oosquare ];
  };
}
