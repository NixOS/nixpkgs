{
  lib,
  stdenv,
  overrideSDK,
  buildNpmPackage,
  fetchFromGitHub,
  substituteAll,

  jq,
  moreutils,
  zip,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  electron_27,

  darwin,
}:

let
  # https://github.com/NixOS/nixpkgs/issues/272156
  # Fixes node c++ addons building on Darwin
  stdenv' = if stdenv.isDarwin then overrideSDK stdenv "11.0" else stdenv;
  buildNpmPackage' = buildNpmPackage.override { stdenv = stdenv'; };

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

  platformInfo = platformInfos.${stdenv'.system};

  # Electron 27 is the latest version that works as of RIDE version 4.5.4097
  electron = electron_27;
  electronDir = "${electron}/${if stdenv'.isDarwin then "Applications" else "libexec/electron"}";
in
buildNpmPackage' rec {
  pname = "ride";
  version = "4.5.4097";

  src = fetchFromGitHub {
    owner = "Dyalog";
    repo = "ride";
    rev = "v${version}";
    hash = "sha256-xR+HVC1JVrPkgPhIJZxdTVG52+QbanmD1c/uO5l84oc=";
  };

  npmDepsHash = "sha256-EG3pZkjDGBI2dDaQZ6351+oU4xfHd6HNB8eD7ErpYIg=";

  # Fix info in the "about" page, set electron version, set fake-cache as zipdir
  patches = lib.singleton (substituteAll {
    src = ./mk.patch;
    version = version;
    electron_version = electron.version;
  });

  postPatch = ''
    # Use a better TMP directory
    substituteInPlace mk --replace-fail "/tmp/ridebuild" $(mktemp -d)

    # Remove spectron (it would download electron-chromedriver binaries)
    ${jq}/bin/jq 'del(.devDependencies.spectron)' package.json | ${moreutils}/bin/sponge package.json

    # Don't use the non-deterministic glob feature of less
    pushd style

    sed -i "/\*\*/d" layout.less light-theme.less dark-theme.less

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
    copyDesktopItems
  ] ++ lib.optional stdenv'.isDarwin darwin.cctools;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmBuildFlags = platformInfo.buildCmd;

  # This package uses electron-packager instead of electron-builder
  # Here, we create a fake cache of electron zip-files, so electron-packager can copy from it
  postConfigure = ''
    mkdir fake-cache
    cp -r --no-preserve=all ${electronDir} electron-tmp
    pushd electron-tmp
    zip -qr ../fake-cache/electron-v${electron.version}-${platformInfo.zipSuffix}.zip *
    popd
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 D.png $out/share/icons/hicolor/64x64/apps/ride.png
    install -Dm644 D.svg $out/share/icons/hicolor/scalable/apps/ride.svg

    pushd _/ride*/*

    install -Dm644 ThirdPartyNotices.txt -t $out/share/doc/ride

    ${lib.optionalString (stdenv'.isDarwin) ''
      mkdir -p $out/Applications
      cp -r Ride-*.app $out/Applications
      chmod +x $out/Applications/Ride-*.app/Contents/MacOS/Ride-*
      makeWrapper $out/Applications/Ride-*.app/Contents/MacOS/Ride-* $out/bin/ride
    ''}

    ${lib.optionalString (!stdenv'.isDarwin) ''
      mkdir -p $out/share/ride
      cp -r locales resources{,.pak} $out/share/ride
      makeWrapper ${lib.getExe electron} $out/bin/ride \
        --add-flags $out/share/ride/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --inherit-argv0
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
    # Builds fine on darwin, but crashes upon launch. Probably has something to do with code-signing.
    broken = stdenv.isDarwin;
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
