{
  mkDerivation, lib, extra-cmake-modules
, qtbase, qtdeclarative, ki18n, kmime, kpkpass
, poppler, kcontacts, kcalcore
}:

mkDerivation {
  name = "kitinerary";
  meta = {
    license = with lib.licenses; [ lgpl21 ];
    maintainers = [ lib.maintainers.bkchr ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qtbase qtdeclarative ki18n kmime kpkpass poppler
    kcontacts kcalcore
  ];
  outputs = [ "out" "dev" ];
}
