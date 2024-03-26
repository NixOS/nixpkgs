{ lib

, stdenv
, fetchFromGitHub
, buildNpmPackage
, nix-update-script
, electron
, writeShellScriptBin
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, pkg-config
, pixman
, cairo
, pango
, npm-lockfile-fix
, overrideSDK
, darwin
, fetchpatch
}:

let
  # fix for: https://github.com/NixOS/nixpkgs/issues/272156
  buildNpmPackage' =
    buildNpmPackage.override {
      stdenv = if stdenv.isDarwin then overrideSDK stdenv "11.0" else stdenv;
    };
  # update package-lock to fix build errors. this will be resolved in the
  # next patch version of Bruno at which point the patch can be removed entirely.
  # upstream PR: https://github.com/usebruno/bruno/pull/1894
  brunoLockfilePatch_1_12_2 = fetchpatch {
    url = "https://github.com/usebruno/bruno/pull/1894/commits/e3bab23446623315ee674283285a86e210778fe7.patch";
    hash = "sha256-8rYBvgu9ZLXjb9AFyk4yMBVjcyFPmlNi66YEaQGQaKw=";
  };
in
buildNpmPackage' rec {
  pname = "bruno";
  version = "1.12.2";

  src = fetchFromGitHub {
    owner = "usebruno";
    repo = "bruno";
    rev = "v${version}";
    hash = "sha256-C/WeEloUGF0PEfeanm6lHe/MgpcF+g/ZY2tnqXFl9LA=";

    postFetch = ''
      patch -d $out <${brunoLockfilePatch_1_12_2}
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  npmDepsHash = "sha256-Zt5cVB1S86iPYKOUj7FwyR97lwmnFz6sZ+S3Ms/b9+o=";
  npmFlags = [ "--legacy-peer-deps" ];

  nativeBuildInputs = [
    (writeShellScriptBin "phantomjs" "echo 2.1.1")
    pkg-config
  ] ++ lib.optionals (! stdenv.isDarwin) [
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    pixman
    cairo
    pango
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.CoreText
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "bruno";
      desktopName = "Bruno";
      exec = "bruno %U";
      icon = "bruno";
      comment = "Opensource API Client for Exploring and Testing APIs";
      categories = [ "Development" ];
      startupWMClass = "Bruno";
    })
  ];

  postPatch = ''
    substituteInPlace scripts/build-electron.sh \
      --replace 'if [ "$1" == "snap" ]; then' 'exit 0; if [ "$1" == "snap" ]; then'
  '';

  ELECTRON_SKIP_BINARY_DOWNLOAD=1;

  dontNpmBuild = true;
  postBuild = ''
    npm run build --workspace=packages/bruno-common
    npm run build --workspace=packages/bruno-graphql-docs
    npm run build --workspace=packages/bruno-app
    npm run build --workspace=packages/bruno-query

    bash scripts/build-electron.sh

    pushd packages/bruno-electron

    ${if stdenv.isDarwin then ''
    cp -r ${electron}/Applications/Electron.app ./
    find ./Electron.app -name 'Info.plist' | xargs -d '\n' chmod +rw

    substituteInPlace electron-builder-config.js \
      --replace "identity: 'Anoop MD (W7LPPWA48L)'" 'identity: null' \
      --replace "afterSign: 'notarize.js'," ""

    npm exec electron-builder -- \
      --dir \
      --config electron-builder-config.js \
      -c.electronDist=./ \
      -c.electronVersion=${electron.version} \
      -c.npmRebuild=false
    '' else ''
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version} \
      -c.npmRebuild=false
    ''}

    popd
  '';

  npmPackFlags = [ "--ignore-scripts" ];

  installPhase = ''
    runHook preInstall


    ${if stdenv.isDarwin then ''
    mkdir -p $out/Applications

    cp -R packages/bruno-electron/out/**/Bruno.app $out/Applications/
    '' else ''
    mkdir -p $out/opt/bruno $out/bin

    cp -r packages/bruno-electron/dist/linux*-unpacked/{locales,resources{,.pak}} $out/opt/bruno

    makeWrapper ${lib.getExe electron} $out/bin/bruno \
      --add-flags $out/opt/bruno/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    for s in 16 32 48 64 128 256 512 1024; do
      size=${"$"}{s}x$s
      install -Dm644 $src/packages/bruno-electron/resources/icons/png/$size.png $out/share/icons/hicolor/$size/apps/bruno.png
    done
    ''}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Open-source IDE For exploring and testing APIs.";
    homepage = "https://www.usebruno.com";
    inherit (electron.meta) platforms;
    license = licenses.mit;
    maintainers = with maintainers; [ water-sucks lucasew kashw2 mattpolzin ];
    mainProgram = "bruno";
  };
}
