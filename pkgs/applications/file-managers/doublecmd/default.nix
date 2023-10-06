{ lib
, stdenv
, fetchFromGitHub
, dbus
, fpc
, getopt
, glib
, lazarus
, libX11
, libqt5pas
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doublecmd";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "doublecmd";
    repo = "doublecmd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IccM7AwPiOtGHjAzvjQ99mrLFh8iZu8G7Rf71LJHB/g=";
  };

  nativeBuildInputs = [
    fpc
    getopt
    lazarus
    wrapQtAppsHook
  ];

  buildInputs = [
    dbus
    glib
    libX11
    libqt5pas
  ];

  NIX_LDFLAGS = "--as-needed -rpath ${lib.makeLibraryPath finalAttrs.buildInputs}";

  postPatch = ''
    patchShebangs build.sh install/linux/install.sh
    substituteInPlace build.sh \
      --replace '$(which lazbuild)' '"${lazarus}/bin/lazbuild --lazarusdir=${lazarus}/share/lazarus"'
    substituteInPlace install/linux/install.sh \
      --replace '$DC_INSTALL_PREFIX/usr' '$DC_INSTALL_PREFIX'
  '';

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    ./build.sh release qt5

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install/linux/install.sh -I $out

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://doublecmd.sourceforge.io/";
    description = "Two-panel graphical file manager written in Pascal";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
  };
})
# TODO: deal with other platforms too
