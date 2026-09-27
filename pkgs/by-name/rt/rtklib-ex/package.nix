{
  stdenv,
  cmake,
  nix-update-script,
  blas,
  lapack,
  lib,
  fetchFromGitHub,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtklib-ex";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "rtklibexplorer";
    repo = "RTKLIB";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IGjrLuw3q0J6NXv2+Y3N22+nBu31W63QkmZpuHuvQnc=";
  };

  nativeBuildInputs = [
    cmake
    blas
    lapack
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtserialport
  ];

  doCheck = true;

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_DATAROOTDIR" "${placeholder "out"}/share")
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open Source Program Package for GNSS Positioning";
    homepage = "https://rtkexplorer.com";
    changelog = "https://github.com/rtklibexplorer/RTKLIB/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.skaphi ];
    platforms = lib.platforms.linux;
  };
})
