{
  lib,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
  qt6,
  qt6Packages,
  cmake,
  alsa-lib,
  pandoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kmidimon";
  version = "1.4.1";
  src = fetchFromGitHub {
    owner = "pedrolcl";
    repo = "kmidimon";
    tag = "RELEASE_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-cITRv/k7NJvTPJYNjDXb21ctr69ThIJppmBwrmj7O74=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    pandoc
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    qt6.qt5compat
    qt6Packages.drumstick
    alsa-lib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Drumstick MIDI Monitor";
    longDescription = ''
      Drumstick MIDI Monitor logs MIDI events coming from MIDI external ports or
      applications via the ALSA sequencer, and from SMF (Standard MIDI files) or
      WRK (Cakewalk/Sonar) files. It is especially useful for debugging MIDI
      software or your MIDI setup.
    '';
    homepage = "https://github.com/pedrolcl/kmidimon";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ qweered ];
    platforms = lib.platforms.linux;
  };
})
