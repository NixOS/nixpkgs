{
  lib,
  stdenv,
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

  # Electron 27 is the latest version that works as of RIDE version 4.5.4097
  electron = electron_27;
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

  npmDepsHash = "sha256-EG3pZkjDGBI2dDaQZ6351+oU4xfHd6HNB8eD7ErpYIg=";

  patches = [
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

  nativeBuildInputs = [
    zip
    makeWrapper
    copyDesktopItems
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmBuildFlags = platformInfo.buildCmd;

  # This package uses electron-packager instead of electron-builder
  # Here, we create a local cache of electron zip-files, so electron-packager can copy from it
  postConfigure = ''
    mkdir local-cache
    cp -r --no-preserve=all ${electron}/libexec/electron electron
    pushd electron
    zip -qr ../local-cache/electron-v${electron.version}-${platformInfo.zipSuffix}.zip *
    popd
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 D.png $out/share/icons/hicolor/64x64/apps/ride.png
    install -Dm644 D.svg $out/share/icons/hicolor/scalable/apps/ride.svg

    pushd _/ride*/*

    install -Dm644 ThirdPartyNotices.txt -t $out/share/doc/ride

    mkdir -p $out/share/ride
    cp -r locales resources{,.pak} $out/share/ride
    makeWrapper ${lib.getExe electron} $out/bin/ride \
      --add-flags $out/share/ride/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --inherit-argv0

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
