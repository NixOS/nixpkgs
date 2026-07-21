{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  makeWrapper,
  electron,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "folia-major";
  version = "0.5.27";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chthollyphile";
    repo = "folia-major";
    tag = "v${finalAttrs.version}";
    hash = "sha256-47W6nFDJlF9/voITX2nd9ZrH8gl+GNtESv1T6AXL3F4=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-lLxa6fT35w+qdn08aNCi6Og/eFs72E8FfHTVM+fIvq8=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    makeWrapper
    copyDesktopItems
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    ELECTRON_DEV = "false";
    ELECTRON = "true";
  };

  # workaround for https://github.com/electron/electron/issues/31121
  postPatch = ''
    substituteInPlace electron/main.cjs \
      --replace-fail "process.resourcesPath" "'$out/lib/folia-major/resources'"

    substituteInPlace vite.config.ts \
      --replace-fail "git rev-parse --short HEAD" "echo unknown" \
      --replace-fail "git rev-parse --abbrev-ref HEAD" "echo main"
  '';

  buildPhase = ''
    runHook preBuild

    npm run build
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/folia-major
    cp -r release/*-unpacked/{locales,resources{,.pak}} $out/lib/folia-major/

    install -D build/icon.png $out/share/icons/hicolor/512x512/apps/folia-major.png

    makeWrapper '${lib.getExe electron}' $out/bin/folia-major \
      --add-flags $out/lib/folia-major/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "folia-major";
      desktopName = "Folia";
      exec = "folia-major";
      terminal = false;
      type = "Application";
      icon = "folia-major";
      startupWMClass = "folia";
      comment = "Lyrics Reimagine";
      categories = [
        "AudioVideo"
        "Player"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Lyrics Reimagine desktop app";
    homepage = "https://folia-site.vercel.app/";
    downloadPage = "https://github.com/chthollyphile/folia-major/releases";
    license = lib.licenses.agpl3Only;
    mainProgram = "folia-major";
    maintainers = with lib.maintainers; [ chillcicada ];
    platforms = lib.platforms.linux;
  };
})
