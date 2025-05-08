{
  lib,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
  qt6,
  kdePackages,
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

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    pandoc
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    qt6.qt5compat
    alsa-lib
    kdePackages.drumstick
  ];

  meta = {
    description = "Kontakt MIDI Monitor";
    homepage = "https://sourceforge.net/projects/kmidimon/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
})
