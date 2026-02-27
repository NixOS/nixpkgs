{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeDesktopItem,
  desktopToDarwinBundle,
  pnpmConfigHook,
  makeWrapper,
  removeReferencesTo,
  copyDesktopItems,
  pnpm_10,
  nodejs,
  electron_38,
  zip,
}:
let
  electron = electron_38;
  stdenv = stdenvNoCC;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "stoat-desktop";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "stoatchat";
    repo = "for-desktop";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-vMXnBniA0wyoK7Pe13h/yHtf8ky59ts4VQb9k7KuUCE=";
  };

  postPatch = ''
    # Disable auto-updates
    sed -i '/updateElectronApp([^)]*)/d' src/main.ts
  '';

  strictDeps = true;
  __structuredAttrs = true;
  doCheck = true;

  nativeBuildInputs = [
    pnpmConfigHook
    removeReferencesTo
    makeWrapper
    copyDesktopItems
    nodejs
    pnpm_10
    zip
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    pnpm = pnpm_10;
    hash = "sha256-m0EuM8qTCFLxxO0RNze5WgMkuHZXeIi+U/Jiuv91eCg=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  buildPhase = ''
    runHook preBuild

    export npm_config_nodedir=${electron.headers}

    # override the detected electron version
    substituteInPlace node_modules/@electron-forge/core-utils/dist/electron-version.js \
      --replace-fail "return version" "return '${electron.version}'"

    # create the electron archive to be used by electron-packager
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pushd electron-dist
    zip -0Xqr ../electron.zip .
    popd

    rm -r electron-dist

    # force @electron/packager to use our electron instead of downloading it
    substituteInPlace node_modules/@electron/packager/dist/packager.js \
      --replace-fail "await this.getElectronZipPath(downloadOpts)" "'$(pwd)/electron.zip'"


    pnpm make \
      --arch "${stdenv.hostPlatform.node.arch}" \
      --platform "${stdenv.hostPlatform.node.platform}" \
      --targets "@electron-forge/maker-zip"

    runHook postBuild
  '';

  installPhase = lib.concatStringsSep "\n" [
    "runHook preInstall"
    # Make freedesktop stuff, then the convert hook should make them for Darwin
    ''
      install -Dm444 "assets/desktop/icon.svg" "$out/share/icons/hicolor/scalable/apps/stoat-desktop.svg"
    ''
    (lib.optionalString stdenv.hostPlatform.isLinux ''
      # remove references to nodejs
      find out/*/resources/app/node_modules -type f -executable -exec remove-references-to -t ${nodejs} '{}' \;

      mkdir -p "$out/share/stoat-desktop"
      cp -r out/*/resources{,.pak} "$out/share/stoat-desktop"

      makeWrapper ${lib.getExe electron} "$out/bin/stoat-desktop" \
        --add-flag $out/share/stoat-desktop/resources/app.asar \
        --set ELECTRON_FORCE_IS_PACKAGED 1 \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --inherit-argv0
    '')
    (lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/Applications"
      cp -r out/*/Stoat.app

      makeWrapper "$out/Applications/Stoat.app/Contents/MacOS/stoat-desktop" "$out/bin/stoat-desktop" \
        --set ELECTRON_FORCE_IS_PACKAGED 1 \
        --inherit-argv0
    '')
    "runHook postInstall"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Stoat";
      exec = "${finalAttrs.meta.mainProgram} %u";
      icon = "${finalAttrs.meta.mainProgram}";
      desktopName = "Stoat";
      genericName = "Chat Client";
      categories = [
        "Network"
        "Chat"
        "InstantMessaging"
      ];
      startupNotify = false;
    })
  ];

  meta = {
    description = "Open source user-first chat platform";
    homepage = "https://stoat.chat/";
    changelog = "https://github.com/stoatchat/for-desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      heyimnova
      magistau
      v3rm1n0
      RossSmyth
    ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "stoat-desktop";
  };
})
