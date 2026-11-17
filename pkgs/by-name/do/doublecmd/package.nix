{
  lib,
  stdenv,
  fetchFromGitHub,
  dbus,
  fpc,
  getopt,
  glib,
  lazarus,
  libx11,
  libsForQt5,
  lua5_5,
  libssh2,
  replaceVars,
  writableTmpDirAsHomeHook,
}:

let
  lua = lua5_5;
  widgetset = if stdenv.hostPlatform.isDarwin then "cocoa" else "qt5";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "doublecmd";
  version = "1.2.11";

  src = fetchFromGitHub {
    owner = "doublecmd";
    repo = "doublecmd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pl/0YmZxPZfb+nubzig9DmyGonvnitVPr5f4n8ll3Bs=";
  };

  patches = [
    (replaceVars ./nix-paths.patch {
      inherit lazarus;
      libssh2 = lib.getLib libssh2;
    })
  ];

  nativeBuildInputs = [
    fpc
    getopt
    lazarus
    writableTmpDirAsHomeHook
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) libsForQt5.wrapQtAppsHook;

  buildInputs = [
    dbus
    glib
    libx11
    libssh2
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) libsForQt5.libqtpas;

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isLinux "--as-needed -rpath ${lib.makeLibraryPath finalAttrs.buildInputs}";

  postPatch = ''
    substituteInPlace src/platform/udcversion.pas \
      --replace-fail '{$I %DATE%}' "'$(date -u -d "@$SOURCE_DATE_EPOCH" +%Y/%m/%d)'"
    substituteInPlace install/linux/install.sh \
      --replace-fail '$DC_INSTALL_PREFIX/usr' '$DC_INSTALL_PREFIX'
    patchShebangs build.sh install/${
      if stdenv.hostPlatform.isDarwin then "darwin" else "linux"
    }/install.sh
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh release ${widgetset}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          rm -f doublecmd.app/Contents/MacOS/doublecmd
          install/darwin/install.sh "$out/Applications"
          mv "$out/Applications/doublecmd.app" "$out/Applications/Double Commander.app"
          cd "$out/Applications/Double Commander.app/Contents/MacOS"
          ln -vs ${lib.getLib lua}/lib/liblua.${lua.version}.dylib ./liblua.dylib
          mkdir -p $out/bin
          ln -s "../Applications/Double Commander.app/Contents/MacOS/doublecmd" $out/bin/doublecmd
        ''
      else
        ''
          install/linux/install.sh -I $out
          cd $out/lib64/doublecmd
          ln -vs ${lib.getLib lua}/lib/liblua.so.${lua.version}
          ln -vs ./liblua.so.${lua.version} ./liblua.so
          ln -vs ./liblua.so.${lua.version} ./liblua.so.${lib.versions.majorMinor lua.version}
        ''
    }

    runHook postInstall
  '';

  meta = {
    homepage = "https://doublecmd.sourceforge.io/";
    description = "Two-panel graphical file manager written in Pascal";
    license = lib.licenses.gpl2Plus;
    mainProgram = "doublecmd";
    maintainers = [ lib.maintainers.gordon01 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
