{
  mkDerivation, lib, extra-cmake-modules
, qtbase, qtdeclarative, ki18n, kmime, kpkpass
, poppler, kcontacts, kcalendarcore
, shared-mime-info
}:

mkDerivation {
  name = "kitinerary";
  meta = {
    license = with lib.licenses; [ lgpl21 ];
    maintainers = [ lib.maintainers.bkchr ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    shared-mime-info # for update-mime-database
  ];
  buildInputs = [
    qtbase qtdeclarative ki18n kmime kpkpass poppler
    kcontacts kcalendarcore
  ];
  outputs = [ "out" "dev" ];
}
