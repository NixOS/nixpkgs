{
  lib,
  mkDerivation,
  extra-cmake-modules,
  libGLU,
  kdoctools,
  kdeclarative,
  libkdegames,
}:

mkDerivation {
  pname = "ksudoku";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    libGLU
    kdeclarative
    libkdegames
  ];
  meta = {
    homepage = "https://apps.kde.org/ksudoku/";
    description = "Suduko game";
    mainProgram = "ksudoku";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ ];
  };
}
