{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch,
  substituteAll,
  jq,
  moreutils,
  zip,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  electron,
  cctools,
}:

let
  platformInfos = {
    "x86_64-linux" = {
      zipSuffix = "linux-x64";
      buildCmd = "linux";
    };
    "x86_64-darwin" = {
      zipSuffix = "darwin-x64";
      buildCmd = "osx";
    };
    "aarch64-darwin" = {
      zipSuffix = "darwin-arm64";
      buildCmd = "osxarm";
    };
  };

  platformInfo = platformInfos.${stdenv.system};
in
buildNpmPackage rec {
  pname = "ride";
  version = "4.5.4097";

  src = fetchFromGitHub {
    owner = "Dyalog";
    repo = "ride";
    rev = "v${version}";
    hash = "sha256-xR+HVC1JVrPkgPhIJZxdTVG52+QbanmD1c/uO5l84oc=";
  };

  npmDepsHash = "sha256-h+48/9h7/cD8woyA0UCLtzKuE9jCrfpDk6IeoDWnYik=";

  patches = [
    # Adds support for electron versions >=28
    (fetchpatch {
      name = "bump-electron-version.patch";
      url = "https://github.com/Dyalog/ride/commit/de42ebbd5036cfe0c7e6604296e87cc57ac9d365.patch";
      hash = "sha256-5iKSNcxOOo2fKNvy3Rv+AlH3psYhLWLWUY0l8M6mAD4=";
    })
    # Fix info in the "about" page, set electron version, set local-cache as zipdir
    (substituteAll {
      src = ./mk.patch;
      version = version;
      electron_version = electron.version;
    })
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

  nativeBuildInputs =
    [
      zip
      makeWrapper
    ]
    ++ lib.optionals (!stdenv.isDarwin) [ copyDesktopItems ]
    ++ lib.optionals stdenv.isDarwin [ cctools ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # Fix error: no member named 'aligned_alloc' in the global namespace
  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinSdkVersion "11.0"
  ) "-D_LIBCPP_HAS_NO_LIBRARY_ALIGNED_ALLOCATION=1";

  npmBuildFlags = platformInfo.buildCmd;

  # This package uses electron-packager instead of electron-builder
  # Here, we create a local cache of electron zip-files, so electron-packager can copy from it
  postConfigure = ''
    mkdir local-cache

    # electron files need to be writable on Darwin
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pushd electron-dist
    zip -qr ../local-cache/electron-v${electron.version}-${platformInfo.zipSuffix}.zip *
    popd
  '';

  installPhase = ''
    runHook preInstall

    pushd _/ride*/*

    install -Dm644 ThirdPartyNotices.txt -t $out/share/doc/ride

    ${lib.optionalString (!stdenv.isDarwin) ''
      install -Dm644 $src/D.png $out/share/icons/hicolor/64x64/apps/ride.png
      install -Dm644 $src/D.svg $out/share/icons/hicolor/scalable/apps/ride.svg

      mkdir -p $out/share/ride
      cp -r locales resources{,.pak} $out/share/ride
      makeWrapper ${lib.getExe electron} $out/bin/ride \
          --add-flags $out/share/ride/resources/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
          --inherit-argv0
    ''}

    ${lib.optionalString stdenv.isDarwin ''
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
    changelog = "https://github.com/Dyalog/ride/releases/tag/${src.rev}";
    description = "Remote IDE for Dyalog APL";
    homepage = "https://github.com/Dyalog/ride";
    license = lib.licenses.mit;
    mainProgram = "ride";
    maintainers = with lib.maintainers; [
      tomasajt
      markus1189
    ];
    platforms = lib.attrNames platformInfos;
  };
}
