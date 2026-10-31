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
  version = "2.5.1_pre";

  src = fetchFromGitHub {
    owner = "rtklibexplorer";
    repo = "RTKLIB";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZOfZfUxvpkum1ibn7C3cvK9dQxX8P3Ny+cxS4jj5Fkk=";
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
