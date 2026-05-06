{
  lib,
  stdenv,
  fetchgit,
  qt6,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "2.0.0-beta1";
  pname = "cool-retro-term";

  src = fetchgit {
    url = "https://github.com/Swordfish90/cool-retro-term";
    rev = "4c11f0800ba0ad3d32dd76179b58cf9ea1def412";
    fetchSubmodules = true;
    hash = "sha256-zr/10rBRJ40EmX1wTB9QZuQAljPHoWCDPiS2/6GVfVs=";
  };

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qt5compat
  ];

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  qtWrapperArgs = [
    "--prefix NIXPKGS_QT6_QML_IMPORT_PATH : ${placeholder "out"}/lib/qt-6/qml"
  ];

  preFixup = ''
    if [ -d $out/nix/store ]; then
      find $out/nix/store -name "QMLTermWidget" -type d | while read src; do
        mkdir -p $out/lib/qt-6/qml
        cp -r "$src" $out/lib/qt-6/qml/
      done
      rm -rf $out/nix/store
    fi

    mv $out/usr/share $out/share
    mv $out/usr/bin $out/bin
    rmdir $out/usr
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    ln -s $out/bin/cool-retro-term.app/Contents/MacOS/cool-retro-term $out/bin/cool-retro-term
  '';

  passthru.tests.test = nixosTests.terminal-emulators.cool-retro-term;

  meta = {
    description = "Terminal emulator which mimics the old cathode display";
    longDescription = ''
      cool-retro-term is a terminal emulator which tries to mimic the look and
      feel of the old cathode tube screens. It has been designed to be
      eye-candy, customizable, and reasonably lightweight.
    '';
    homepage = "https://github.com/Swordfish90/cool-retro-term";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = [ ];
    mainProgram = "cool-retro-term";
  };
})
