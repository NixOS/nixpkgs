{ mkDerivation, lib
, libkdegames, extra-cmake-modules
, kdeclarative, knewstuff
}:

mkDerivation {
  name = "bomber";
  meta = with lib; { maintainers = with maintainers; [ freezeboy ]; };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdeclarative
    knewstuff
    libkdegames
  ];
}
