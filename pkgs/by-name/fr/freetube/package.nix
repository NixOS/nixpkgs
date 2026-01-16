{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  replaceVars,
  makeDesktopItem,

  nodejs,
  yarnConfigHook,
  yarnBuildHook,
  makeShellWrapper,
  copyDesktopItems,
  electron,

  nixosTests,
}:
let
  description = "Open Source YouTube app for privacy";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "freetube";
  version = "0.23.12-unstable-2026-01-15";

  src = fetchFromGitHub {
    owner = "FreeTubeApp";
    repo = "FreeTube";
    # tag = "v${finalAttrs.version}-beta";
    rev = "e110a4b603e0f5f275d210aea005698a0d4b26ad";
    hash = "sha256-kq6twf7ce2987iHtwikPzolzzbxr1xcoirqUGpPG4V8=";
  };

  # Darwin requires writable Electron dist
  postUnpack =
    if stdenvNoCC.hostPlatform.isDarwin then
      ''
        cp -r ${electron.dist} electron-dist
        chmod -R u+w electron-dist
      ''
    else
      ''
        ln -s ${electron.dist} source/electron-dist
      '';

  patches = [
    (replaceVars ./patch-build-script.patch {
      electron-version = electron.version;
    })
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-E6D2Uo06MAcnOKy00e5JoLdKQOeGVr7y7Lu6rZ1F82M=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    yarnBuildHook
    makeShellWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    mkdir -p $out/share/freetube
    cp -r build/*-unpacked/{locales,resources{,.pak}} -t $out/share/freetube

    makeWrapper ${lib.getExe electron} $out/bin/freetube \
      --add-flags "$out/share/freetube/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -D _icons/icon.svg $out/share/icons/hicolor/scalable/apps/freetube.svg
  ''
  + lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r build/mac*/FreeTube.app $out/Applications
    ln -s "$out/Applications/FreeTube.app/Contents/MacOS/FreeTube" $out/bin/freetube
  ''
  + ''
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "freetube";
      desktopName = "FreeTube";
      comment = description;
      exec = "freetube %U";
      terminal = false;
      type = "Application";
      icon = "freetube";
      startupWMClass = "FreeTube";
      mimeTypes = [ "x-scheme-handler/freetube" ];
      categories = [ "Network" ];
    })
  ];

  passthru.tests = nixosTests.freetube;

  meta = {
    inherit description;
    homepage = "https://freetubeapp.io/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      ryneeverett
      pentane
      ryand56
      sigmasquadron
      ddogfoodd
    ];
    badPlatforms = [
      # output app is called "Electron.app" while derivation expects "FreeTube.app"
      #see: https://github.com/NixOS/nixpkgs/pull/384596#issuecomment-2677141349
      lib.systems.inspect.patterns.isDarwin
    ];
    inherit (electron.meta) platforms;
    mainProgram = "freetube";
  };
})
