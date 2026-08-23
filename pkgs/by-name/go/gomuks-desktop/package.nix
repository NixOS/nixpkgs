{
  lib,
  stdenv,
  buildNpmPackage,
  makeDesktopItem,
  copyDesktopItems,

  electron_42,
  zip,
  makeWrapper,

  gomuks-web,
}:
let
  electron = electron_42;
in
buildNpmPackage (finalAttrs: {
  pname = "gomuks-desktop";

  __structuredAttrs = true;

  inherit (gomuks-web) version src;
  sourceRoot = "${finalAttrs.src.name}/desktop";

  npmBuildScript = "package";

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-m3T9aPBuknyDIySa2fJagj0xeQmcJ/RgkzlDCsvfTKs=";

  patches = [
    ./gomuks-binary-path.patch # fix location of gomuks-web binary at build-time
    ./resources-path.patch # allow specifying location of icons
  ];

  nativeBuildInputs = [
    zip
    makeWrapper
    copyDesktopItems
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    # electron-forge's console output is squeezed into one narrow column if unset
    CI = "1";
  };

  postConfigure = ''
    # electron files need to be writable on Darwin
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pushd electron-dist
    zip -0Xqr ../electron.zip .
    popd

    rm -r electron-dist

    # force @electron/packager to use our electron instead of downloading it, even if it is a different version
    substituteInPlace node_modules/@electron/packager/dist/packager.js \
        --replace-fail 'await this.getElectronZipPath(downloadOpts)' '"electron.zip"'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/gomuks-desktop
    cp -r out/gomuks-desktop-*/resources $out/share/gomuks-desktop

    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp $src/desktop/icon.png $out/share/icons/hicolor/512x512/apps/gomuks-desktop.png

    makeWrapper ${lib.getExe electron} $out/bin/gomuks-desktop \
      --add-flags $out/share/gomuks-desktop/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default GOMUKS_DESKTOP_BINARY_PATH ${gomuks-web}/bin/gomuks-web \
      --set-default GOMUKS_DESKTOP_RESOURCES_PATH $out/share/gomuks-desktop/resources/ \
      --inherit-argv0

    runHook copyDesktopItems
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "gomuks-desktop";
      comment = "Matrix client written in Go (Electron frontend)";
      genericName = "Matrix Client";
      desktopName = "Gomuks";
      exec = "gomuks-desktop %u";
      terminal = false;
      type = "Application";
      icon = "gomuks-desktop";
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      mimeTypes = [ "x-scheme-handler/matrix" ];
    })
  ];

  meta = {
    homepage = "https://maunium.net/go/gomuks/";
    description = "${gomuks-web.meta.description} (Electron frontend)";
    mainProgram = "gomuks-desktop";
    inherit (gomuks-web.meta) license;
    maintainers = with lib.maintainers; [
      logn
      xaltsc
    ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
