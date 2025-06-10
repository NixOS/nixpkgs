{
  lib,
  stdenv,
  fetchFromGitHub,
  dbus,
  fpc,
  getopt,
  glib,
  lazarus,
  libX11,
  libqtpas,
  wrapQtAppsHook,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doublecmd";
  version = "1.1.26";

  src = fetchFromGitHub {
    owner = "doublecmd";
    repo = "doublecmd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1rUAyI+Qe4I6F1T9KxMxHxedcARav6CE8W5qvWLu8Y0=";
  };

  nativeBuildInputs = [
    fpc
    getopt
    lazarus
    wrapQtAppsHook
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    dbus
    glib
    libX11
    libqtpas
  ];

  env.NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath finalAttrs.buildInputs}";

  postPatch = ''
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

    runHook postInstall
  '';

  meta = {
    homepage = "https://doublecmd.sourceforge.io/";
    description = "Two-panel graphical file manager written in Pascal";
    license = lib.licenses.gpl2Plus;
    mainProgram = "doublecmd";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
# TODO: deal with other platforms too
