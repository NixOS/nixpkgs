{
  lib,
  stdenv,
  buildNpmPackage,

  fetchFromGitHub,
  runCommand,
  replaceVars,

  makeWrapper,

  electron,
  commandLineArgs ? "",
}:

let
  # unpack tarball containing electron's headers
  electron-headers = runCommand "electron-headers" { } ''
    mkdir -p $out
    tar -C $out --strip-components=1 -xvf ${electron.headers}
  '';
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

    export npm_config_nodedir=${electron-headers}

    # TODO: remove
    npm rebuild --verbose
  '';

  npmBuildScript = "pack:dir";

  installPhase =
    ''
      runHook preInstall
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p "$out/opt/lx-music-desktop"
      cp -r build/*-unpacked/{locales,resources{,.pak}} "$out/opt/lx-music-desktop"
      rm "$out/opt/lx-music-desktop/resources/app-update.yml"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -r build/mac*/lx-music-desktop.app $out/Applications
      makeWrapper $out/Applications/lx-music-desktop.app/Contents/MacOS/lx-music-desktop $out/bin/lx-music-desktop
    ''
    + ''
      runHook postInstall
    '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    makeWrapper ${electron}/bin/electron $out/bin/lx-music-desktop \
        --add-flags $out/opt/lx-music-desktop/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --add-flags ${lib.escapeShellArg commandLineArgs}
  '';

  meta = with lib; {
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
