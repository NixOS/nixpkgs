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
  writableTmpDirAsHomeHook,
}:

let
  lua = lua5_5;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "doublecmd";
  version = "1.2.9";

  src = fetchFromGitHub {
    owner = "doublecmd";
    repo = "doublecmd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UuwE4ptOdrh00Rec7CjPPJoA9Qo4S19GwSbLNQn+Uac=";
  };

  nativeBuildInputs = [
    fpc
    getopt
    lazarus
    libsForQt5.wrapQtAppsHook
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    dbus
    glib
    libx11
    libsForQt5.libqtpas
  ];

  env.NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath finalAttrs.buildInputs}";

  postPatch = ''
    # Double Commander saves this default into the user's configuration, so use
    # the symlink installed next to the executable instead of a store path.
    substituteInPlace src/platform/lua.pas \
      --replace-fail "LuaDLL = 'liblua5.1.so.0';" "LuaDLL = '%COMMANDER_PATH%/liblua.so';"
    patchShebangs build.sh install/linux/install.sh
    substituteInPlace build.sh \
      --replace-warn '$(which lazbuild)' '"${lazarus}/bin/lazbuild --lazarusdir=${lazarus}/share/lazarus"'
    substituteInPlace install/linux/install.sh \
      --replace-warn '$DC_INSTALL_PREFIX/usr' '$DC_INSTALL_PREFIX'
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh release qt5

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install/linux/install.sh -I $out

    cd $out/lib64/doublecmd

    ln -vs ${lib.getLib lua}/lib/liblua.so.${lua.version}

    ln -vs ./liblua.so.${lua.version} ./liblua.so
    ln -vs ./liblua.so.${lua.version} ./liblua.so.${lib.versions.majorMinor lua.version}

    runHook postInstall
  '';

  meta = {
    homepage = "https://doublecmd.sourceforge.io/";
    description = "Two-panel graphical file manager written in Pascal";
    license = lib.licenses.gpl2Plus;
    mainProgram = "doublecmd";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
# TODO: deal with other platforms too
