{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  copyDesktopItems,
  makeWrapper,
  nodejs_22,
  pnpm_10,
  yq-go,
  electron_37,
  makeDesktopItem,
  nix-update-script,
  commandLineArgs ? "",
}:

let
  cpu =
    if stdenv.hostPlatform.isx86_64 then
      "x64"
    else if stdenv.hostPlatform.isAarch64 then
      "arm64"
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";

  electron = electron_37;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hayase";
  version = "6.4.21-unstable-2025-08-04";

  src = fetchFromGitHub {
    owner = "hayase-app";
    repo = "electron";
    rev = "0d2f6e97d5285cfd5e86948eb39acbd1e26e86eb";
    hash = "sha256-sA+BAIM2pgYu6CnP3kTWAFOb6+rV+5aukDGhVGAWWqI=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-Qy23pjT9ReybmRglp6OuUWq4y+nhxOEpuIKZPOk1Mnc=";
  };

  postPatch = ''
    yq eval -i 'del(.linux.target[] | select(.target=="AppImage")) | (.linux.target[] | select(.target=="deb") | .target)="dir"' electron-builder.yml
    yq eval -i '.linux.target[0].arch=["${cpu}"]' electron-builder.yml
    yq eval -i '.mac.defaultArch="${cpu}" | .mac.target[0].arch=["${cpu}"]' electron-builder.yml
    yq eval -i '.mac.hardenedRuntime=false | .mac.notarize=false | del(.mac.entitlementsInherit)' electron-builder.yml
    yq eval -i '.mac.target[0].target = "dir"' electron-builder.yml
    yq eval -i '.mac.identity = null' electron-builder.yml
    substituteInPlace src/main/app.ts \
      --replace-fail "is.dev" "false"
  '';

  nativeBuildInputs = [
    pnpm_10.configHook
    nodejs_22
    electron
    yq-go
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

  env = {
    ELECTRON_OVERRIDE_DIST_PATH = electron.dist;
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    ELECTRON_EXEC_PATH = lib.getExe electron;
    NODE_ENV = "production";
  };

  buildPhase = ''
    runHook preBuild

    rm --recursive electron-dist
    cp --recursive --no-preserve=mode ${electron.dist} electron-dist
    pnpm exec electron-vite -- build --mode production
    pnpm exec electron-builder -- \
      --config electron-builder.yml \
      --dir \
      -p never \
      --config.electronDist=${electron.dist} \
      --config.electronVersion=${electron.version} \
      --config.mac.identity=null

    runHook postBuild
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "hayase";
      exec = "hayase";
      icon = "hayase";
      desktopName = "Hayase";
      categories = [
        "AudioVideo"
        "Video"
      ];
      keywords = [ "anime" ];
      mimeTypes = [ "x-scheme-handler/hayase" ];
      terminal = false;
      comment = "Hayase - Torrent streaming made simple";
      startupWMClass = "Hayase";
    })
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/hayase
    ${
      if stdenv.hostPlatform.isAarch64 then
        "cp -r dist/linux-arm64-unpacked/{resources,LICENSE*} $out/share/hayase"
      else
        "cp -r dist/linux-unpacked/{resources,LICENSE*} $out/share/hayase"
    }
    makeWrapper ${lib.getExe electron} $out/bin/hayase \
      --add-flags "$out/share/hayase/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs} \
      --inherit-argv0 \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1
    install -D --mode=0644 build/icon.png "$out/share/icons/hicolor/512x512/apps/hayase.png"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications" "$out/bin"
    cp -r dist/mac/Hayase.app "$out/Applications/"
    chmod 0755 "$out/Applications/Hayase.app/Contents/MacOS/Hayase"
    ln -s "$out/Applications/Hayase.app/Contents/MacOS/Hayase" "$out/bin/hayase"
  ''
  + ''
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Stream anime torrents instantly, real-time with no waiting for downloads to finish";
    homepage = "https://hayase.watch";
    license = lib.licenses.bsl11;
    mainProgram = "hayase";
    maintainers = with lib.maintainers; [ d4ilyrun ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
