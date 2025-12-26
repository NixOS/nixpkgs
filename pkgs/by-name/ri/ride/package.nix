{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch,
  replaceVars,
  jq,
  moreutils,
  zip,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  electron,
}:

buildNpmPackage rec {
  pname = "ride";
  version = "4.6.4265";

  src = fetchFromGitHub {
    owner = "Dyalog";
    repo = "ride";
    tag = "v${version}";
    hash = "sha256-11wlKK0z3/KRKMKNrDvZLvK7vV0UzrMTaG0ei9n6VEk=";
  };

  npmDepsHash = "sha256-1+RjSr5FSaQFqkL/yzlAQhm56NVG2kjzZC/DsEi3HJE=";

  patches = [
    # Fix info in the "about" page, enable asar, add option to build for the detected system
    (replaceVars ./mk.patch {
      inherit version;
    })

    # would not build with nodejs_22 and above without this
    ./update-nan.patch
  ];

  postPatch = ''
    # Remove spectron (it would download electron-chromedriver binaries)
    ${jq}/bin/jq 'del(.devDependencies.spectron)' package.json | ${moreutils}/bin/sponge package.json

    pushd style

    # Remove non-deterministic glob ordering
    sed -i "/\*\*/d" layout.less light-theme.less dark-theme.less

    # Individually include all files that were previously globbed
    shopt -s globstar
    for file in less/layout/**/*.less; do
      echo "@import '$file';" >> layout.less
    done
    for file in less/colour/**/*.less; do
      echo "@import '$file';" >> light-theme.less
      echo "@import '$file';" >> dark-theme.less
    done
    shopt -u globstar

    popd
  '';

  nativeBuildInputs = [
    zip
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ copyDesktopItems ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # our patch adds the platform detecting build option
  npmBuildFlags = "self";

  postConfigure = ''
    # electron files need to be writable on Darwin
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pushd electron-dist
    zip -0Xqr ../electron.zip *
    popd

    rm -r electron-dist

    # force electron-packager to use our electron instead of downloading it, even if it is a different version
    substituteInPlace node_modules/@electron/packager/dist/packager.js \
        --replace-fail 'await this.getElectronZipPath(downloadOpts)' '"electron.zip"'
  '';

  installPhase = ''
    runHook preInstall

    pushd _/ride*/*

    install -Dm644 ThirdPartyNotices.txt -t $out/share/doc/ride

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 $src/D.png $out/share/icons/hicolor/64x64/apps/ride.png
      install -Dm644 $src/D.svg $out/share/icons/hicolor/scalable/apps/ride.svg

      mkdir -p $out/share/ride
      cp -r locales resources{,.pak} $out/share/ride
      makeShellWrapper ${lib.getExe electron} $out/bin/ride \
          --add-flags $out/share/ride/resources/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
          --inherit-argv0
    ''}

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -r Ride-*.app $out/Applications
      makeWrapper $out/Applications/Ride-*.app/Contents/MacOS/Ride-* $out/bin/ride
    ''}

    popd

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ride";
      exec = "ride";
      icon = "ride";
      desktopName = "RIDE";
      categories = [
        "Development"
        "IDE"
      ];
      comment = meta.description;
      terminal = false;
    })
  ];

  meta = {
    changelog = "https://github.com/Dyalog/ride/releases/tag/v${version}";
    description = "Remote IDE for Dyalog APL";
    homepage = "https://github.com/Dyalog/ride";
    license = lib.licenses.mit;
    mainProgram = "ride";
    maintainers = with lib.maintainers; [
      tomasajt
      markus1189
    ];
    platforms = electron.meta.platforms;
  };
}
