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
    patchShebangs build.sh
    substituteInPlace build.sh \
      --replace-warn '$(which lazbuild)' '"${lazarus}/bin/lazbuild --lazarusdir=${lazarus}/share/lazarus"'

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          patchShebangs install/darwin/install.sh

          # Double Commander saves this default into the user's configuration, so use
          # the symlink installed next to the executable instead of a store path.
          substituteInPlace src/platform/lua.pas \
            --replace-fail "LuaDLL = 'liblua5.1.dylib';" "LuaDLL = '%COMMANDER_PATH%/liblua.dylib';"
          substituteInPlace plugins/wfx/ftp/src/sftp/libssh.pas \
            --replace-fail "'libssh2.dylib'" "'${lib.getLib libssh2}/lib/libssh2.dylib'"
        ''
      else
        ''
          patchShebangs install/linux/install.sh
          substituteInPlace install/linux/install.sh \
            --replace-warn '$DC_INSTALL_PREFIX/usr' '$DC_INSTALL_PREFIX'

          # Same as on Darwin: use the symlink installed next to the executable.
          substituteInPlace src/platform/lua.pas \
            --replace-fail "LuaDLL = 'liblua5.1.so.0';" "LuaDLL = '%COMMANDER_PATH%/liblua.so';"
          substituteInPlace plugins/wfx/ftp/src/sftp/libssh.pas \
            --replace-fail "'libssh2.so.1'" "'${lib.getLib libssh2}/lib/libssh2.so.1'"
        ''
    }
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
          install/darwin/install.sh "$TMPDIR"
          mkdir -p $out/Applications
          mv "$TMPDIR/doublecmd.app" $out/Applications/
          cd $out/Applications/doublecmd.app/Contents/MacOS
          ln -vs ${lib.getLib lua}/lib/liblua.${lua.version}.dylib ./liblua.dylib
          mkdir -p $out/bin
          ln -s $out/Applications/doublecmd.app/Contents/MacOS/doublecmd $out/bin/doublecmd
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
# TODO: deal with other platforms too
