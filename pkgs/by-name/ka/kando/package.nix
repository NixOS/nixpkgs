{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,

  electron,
  nodejs,

  cmake,
  zip,
  makeWrapper,
  wayland-scanner,
  copyDesktopItems,
  makeDesktopItem,

  libxkbcommon,
  libX11,
  libXtst,
  libXi,
  wayland,
}:

buildNpmPackage rec {
  pname = "kando";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "kando-menu";
    repo = "kando";
    tag = "v${version}";
    hash = "sha256-pgHhMzObj8Fh6pw1wjJXjghjKzKiM64lXS4Xlwh3omY=";
  };

  npmDepsHash = "sha256-vytwJdVnkm1AlDoM86xh5Vx5lsaDRcNdwjhP43A6KF8=";

  npmFlags = [ "--ignore-scripts" ];

  makeCacheWritable = true;

  nativeBuildInputs = [
    cmake
    zip
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland-scanner
    copyDesktopItems
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libxkbcommon
    libX11
    libXtst
    libXi
    wayland
  ];

  dontUseCmakeConfigure = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    # use our own node headers since we skip downloading them
    NIX_CFLAGS_COMPILE = "-I${nodejs}/include/node";
    # disable code signing on Darwin
    CSC_IDENTITY_AUTO_DISCOVERY = lib.optionalString stdenv.hostPlatform.isDarwin "false";
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

    # don't fetch node headers
    substituteInPlace node_modules/cmake-js/lib/dist.js \
        --replace-fail '!this.downloaded' 'false'
  '';

  # we used --ignore-scripts to have time to patch the dependencies
  # now we'll have to call npm rebuild manually
  preBuild = ''
    npm rebuild --verbose
  '';

  npmBuildScript = "package";

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/share/kando
      cp -r out/*/{locales,resources{,.pak}} $out/share/kando

      install -Dm644 assets/icons/icon.svg $out/share/icons/hicolor/scalable/apps/kando.svg

      makeWrapper ${lib.getExe electron} $out/bin/kando \
          --add-flags $out/share/kando/resources/app \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
          --inherit-argv0
    ''}

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -r out/*/Kando.app $out/Applications
      makeWrapper $out/Applications/Kando.app/Contents/MacOS/Kando $out/bin/kando
    ''}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "kando";
      exec = "kando %U";
      icon = "kando";
      desktopName = "Kando";
      genericName = "Pie Menu";
      comment = "The Cross-Platform Pie Menu";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    changelog = "https://github.com/kando-menu/kando/releases/tag/v${version}";
    description = "Cross-Platform Pie Menu";
    homepage = "https://github.com/kando-menu/kando";
    license = lib.licenses.mit;
    mainProgram = "kando";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = electron.meta.platforms;
  };
}
