{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  copyDesktopItems,
  makeWrapper,
  makeDesktopItem,
  electron_39,
  nodejs_22,
  nix-update-script,

  nodejs ? nodejs_22,
  electron ? electron_39,
}:
buildNpmPackage (finalAttrs: {
  inherit nodejs;

  pname = "openscreen";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "siddharthvaddem";
    repo = "openscreen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NW6GrmWgdLgobYGAoxlSF/ne17A0IzAQBi4LJk2awpw=";
  };

  npmDepsHash = "sha256-IaYSejp4sXEN0KlK7+bmzufGs8D60ZjmFWjO2zMkFrM=";

  npmRebuildFlags = [ "--ignore-scripts" ]; # Prevent running `node-gyp build`

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  patches = [
    # Avoid downloading `phantomjs` within the build sandbox
    # by completely removing `electron-icon-builder`
    ./electron-avoid-phantomjs.patch
  ];

  buildPhase = ''
    runHook preBuild

    npm exec tsc
    npm exec vite build

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      # electronDist needs to be modifiable on Darwin
      cp -r ${electron.dist} electron-dist
      chmod -R u+w electron-dist
      # Disable code signing during build on macOS.
      # https://github.com/electron-userland/electron-builder/blob/fa6fc16/docs/code-signing.md#how-to-disable-code-signing-during-the-build-process-on-macos
      export CSC_IDENTITY_AUTO_DISCOVERY=false
    ''}
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      ln -s ${electron.dist} electron-dist
    ''}

    npm exec electron-builder -- \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/share/openscreen
      cp -r release/*/*-unpacked/{locales,resources{,.pak}} $out/share/openscreen

      makeWrapper ${lib.getExe electron} $out/bin/openscreen \
          --add-flags $out/share/openscreen/resources/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
          --set-default ELECTRON_IS_DEV 0 \
          --inherit-argv0

      install -Dm644 icons/icons/png/512x512.png $out/share/icons/hicolor/512x512/apps/openscreen.png
    ''}

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -R release/*/mac*/Openscreen.app $out/Applications/
      makeWrapper $out/Applications/Openscreen.app/Contents/MacOS/Openscreen $out/bin/openscreen
    ''}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "openscreen";
      desktopName = "OpenScreen";
      comment = finalAttrs.meta.description;
      icon = "openscreen";
      exec = "openscreen %u";
      categories = [
        "AudioVideo"
        "Video"
        "Utility"
      ];
      terminal = false;
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Free, open-source alternative to Screen Studio (sort of)";
    homepage = "https://openscreen.vercel.app";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Renna42
    ];
    mainProgram = "openscreen";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
