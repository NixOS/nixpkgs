{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchPnpmDeps,
  replaceVars,
  makeDesktopItem,

  nodejs,
  pnpmConfigHook,
  pnpmBuildHook,
  pnpm_10,
  makeShellWrapper,
  copyDesktopItems,
  electron,

  nixosTests,
}:
let
  description = "Open Source YouTube app for privacy";
  pnpm = pnpm_10;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "freetube";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "FreeTubeApp";
    repo = "FreeTube";
    tag = "v${finalAttrs.version}-beta";
    hash = "sha256-oXa+3BXLVDTaLUzt0imgTtZ4/NywibFzul/y0wymnWk=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  # Darwin requires writable Electron dist
  postUnpack =
    if stdenvNoCC.hostPlatform.isDarwin then
      ''
        cp -r ${electron.dist} source/electron-dist
        chmod -R u+w source/electron-dist
      ''
    else
      ''
        ln -s ${electron.dist} source/electron-dist
      '';

  patches = [
    (replaceVars ./patch-build-script.patch {
      electron-version = electron.version;
    })
    ./targets.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-xHlxmeMtMd9/ImheeMH1K22MC0zmIzzgAHXzK+tLnQc=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpmBuildHook
    pnpm
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
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -D _icons/icon.svg $out/share/icons/hicolor/scalable/apps/freetube.svg
  ''
  + lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
    mkdir -p $out/Applications $out/bin
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
    inherit (electron.meta) platforms;
    mainProgram = "freetube";
  };
})
