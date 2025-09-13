{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "laigter";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "azagaya";
    repo = "laigter";
    tag = finalAttrs.version;
    hash = "sha256-1QSvUTOKKKx4LVHezYzXs8Z7IAYLSTzuEt0RA37T6UU";
  };

  strictDeps = true;
  buildInputs = [ qt6.qtbase ];
  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
  ];
  enableParallelBuilding = true;

  qmakeFlags = [
    # XXX: Qmake assumes that "lrelease" is in "${qt6.qtbase}/bin", so we need
    # to override the location.
    # Issue: https://github.com/NixOS/nixpkgs/issues/214765
    "QT_TOOL.lrelease.binary=${lib.getDev qt6.qttools}/bin/lrelease"
  ];

  meta = {
    description = "Automatic normal map generator for sprites";
    changelog = with finalAttrs.src; "${meta.homepage}/releases/tag/${tag}";
    homepage = "https://azagaya.itch.io/laigter";
    license = lib.licenses.gpl3Plus;
    mainProgram = "laigter";
    maintainers = [ lib.maintainers.aszlig ];
  };
})
