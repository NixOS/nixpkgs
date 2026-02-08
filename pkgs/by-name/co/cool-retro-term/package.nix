{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.2.0";
  pname = "cool-retro-term";

  src = fetchFromGitHub {
    owner = "Swordfish90";
    repo = "cool-retro-term";
    tag = finalAttrs.version;
    hash = "sha256-PewHLVmo+RTBHIQ/y2FBkgXsIvujYd7u56JdFC10B4c=";
  };

  patchPhase = ''
    sed -i -e '/qmltermwidget/d' cool-retro-term.pro
  '';

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qmltermwidget
    libsForQt5.qtquickcontrols2
    libsForQt5.qtgraphicaleffects
  ];

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  preFixup = ''
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
