{
  lib,
  stdenv,
  fetchFromGitLab,
  libarchive,
  xz,
  zlib,
  bzip2,
  meson,
  pkg-config,
  ninja,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libarchive-qt";
  version = "2.0.8";

  src = fetchFromGitLab {
    owner = "marcusbritanicus";
    repo = "libarchive-qt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-31a6DsxObSJWyLfT6mVtyjloT26IwFHpH53iuyC2mco=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    qt6.wrapQtAppsNoGuiHook
  ];

  buildInputs = [
    libarchive
    bzip2
    zlib
    xz
    qt6.qtbase
  ];

  mesonFlags = [ "-Duse_qt_version=qt6" ];

  meta = {
    description = "Qt based archiving solution with libarchive backend";
    mainProgram = "archiver";
    homepage = "https://gitlab.com/marcusbritanicus/libarchive-qt";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
