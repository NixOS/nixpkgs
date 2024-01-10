{ lib

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
}:

buildNpmPackage rec {
  pname = "bruno";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "usebruno";
    repo = "bruno";
    rev = "v${version}";
    hash = "sha256-GgXnsPEUurPHrijf966x5ldp+1lDrgS1iBinU+EkdYU=b";

    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  npmDepsHash = "sha256-R5dEL4QbwCSE9+HHCXlf/pYLmjCaD15tmdSSLbZgmt0=";

  nativeBuildInputs = [
    (writeShellScriptBin "phantomjs" "echo 2.1.1")
    makeWrapper
    copyDesktopItems
    pkg-config
  ];

  buildInputs = [
    pixman
    cairo
    pango
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
    npm run build --workspace=packages/bruno-graphql-docs
    npm run build --workspace=packages/bruno-app
    npm run build --workspace=packages/bruno-query

    bash scripts/build-electron.sh

    pushd packages/bruno-electron

    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron}/libexec/electron \
      -c.electronVersion=${electron.version} \
      -c.npmRebuild=false

    popd
  '';

  npmPackFlags = [ "--ignore-scripts" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/bruno $out/bin

    cp -r packages/bruno-electron/dist/linux-unpacked/{locales,resources{,.pak}} $out/opt/bruno

    makeWrapper ${lib.getExe electron} $out/bin/bruno \
      --add-flags $out/opt/bruno/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    for s in 16 32 48 64 128 256 512 1024; do
      size=${"$"}{s}x$s
      install -Dm644 $src/packages/bruno-electron/resources/icons/png/$size.png $out/share/icons/hicolor/$size/apps/bruno.png
    done

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Open-source IDE For exploring and testing APIs.";
    homepage = "https://www.usebruno.com";
    inherit (electron.meta) platforms;
    license = licenses.mit;
    maintainers = with maintainers; [ water-sucks lucasew kashw2 ];
    mainProgram = "bruno";
  };
}
