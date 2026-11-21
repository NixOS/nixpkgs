{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  nix-update-script,
  electron,
  nodejs,
  gitMinimal,
  zip,
  openssl,
  dbus,
}:

buildNpmPackage (finalAttrs: {
  pname = "mautrix-manager";
  version = "0.2.1";

  __structuredAttrs = true;

  inherit nodejs;

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B+HhA+0XR+UWbVYTbH7QzPG+nzhDAXlc4AuspB2sYiI=";
  };

  npmDepsHash = "sha256-sGvpBx0JiY8tv43hoABRtdamdFNm1C1JFWBLYlV9UNw=";

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    gitMinimal # Used by electron-forge
    zip
  ];

  env = {
    # The npm `electron` dependency tries to download its own binary, which we
    # don't need as we run against the Nixpkgs-packaged Electron instead.
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    # Prevent electron-forge's fancy UI from spamming the build logs.
    CI = "1";
  };

  # The npm cache from prefetch-npm-deps is root-owned, make it writable.
  makeCacheWritable = true;

  npmBuildScript = "package";

  postConfigure = ''
    # override the electron version detected by electron-forge
    substituteInPlace node_modules/@electron-forge/core-utils/dist/electron-version.js \
      --replace-fail "return version" "return '${electron.version}'"

    # tell electron-packager to look for Electron zips in a local dir
    # instead of downloading them from the internet
    substituteInPlace node_modules/@electron/packager/dist/packager.js \
      --replace-fail 'await this.getElectronZipPath(downloadOpts)' '"electron.zip"'
  '';

  preBuild = ''
    # create the electron archive to be used by electron-packager
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pushd electron-dist
    zip -0Xqr ../electron.zip .
    popd

    rm -r electron-dist
  '';

  installPhase = ''
    runHook preInstall

    # the output of electron-forge is here
    build_dir=$(find out -maxdepth 1 -mindepth 1 -type d | head -n1)

    appdir=$out/share/mautrix-manager
    mkdir -p $appdir
    cp -r $build_dir/resources/* $appdir/

    install -Dm644 icon.png $out/share/icons/hicolor/256x256/apps/mautrix-manager.png

    # The @beeper/webauthn-authenticator native module needs libssl/libcrypto/
    # libdbus at runtime, which Electron does not expose to dlopen'd modules.
    makeWrapper ${lib.getExe electron} $out/bin/mautrix-manager \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          openssl
          dbus
        ]
      } \
      --add-flags $appdir/app.asar \
      --add-flags "''${NIXOS_OZONE_WL:+''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "mautrix-manager";
      desktopName = "mautrix-manager";
      comment = finalAttrs.meta.description;
      exec = "mautrix-manager %U";
      icon = "mautrix-manager";
      startupNotify = true;
      categories = [
        "Network"
        "Chat"
      ];
      mimeTypes = [ "x-scheme-handler/mautrix-manager" ];
    })
  ];

  meta = {
    description = "Electron app to help with logging into mautrix bridges";
    homepage = "https://github.com/mautrix/manager";
    changelog = "https://github.com/mautrix/manager/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ eymeric ];
    mainProgram = "mautrix-manager";
    inherit (electron.meta) platforms;
  };
})
