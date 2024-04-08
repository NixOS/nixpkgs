{ lib
, mkDerivation
, extra-cmake-modules
, kdoctools
, kdeclarative
, knewstuff
, libkdegames
, libkmahjongg
}:

mkDerivation {
  pname = "kmahjongg";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kdeclarative libkmahjongg knewstuff libkdegames ];
  meta = {
    description = "Mahjongg solitaire";
    mainProgram = "kmahjongg";
    homepage = "https://apps.kde.org/kmahjongg/";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ ];
  };
}
