{
  mkDerivation,
  lib,
  extra-cmake-modules,
  qtdeclarative,
  ki18n,
  kmime,
  kpkpass,
  poppler,
  kcontacts,
  kcalendarcore,
  shared-mime-info,
  zxing-cpp,
}:

mkDerivation {
  pname = "kitinerary";
  meta = {
    license = with lib.licenses; [ lgpl21 ];
    maintainers = [ lib.maintainers.bkchr ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    shared-mime-info # for update-mime-database
  ];
  buildInputs = [
    qtdeclarative
    kmime
    kpkpass
    poppler
    kcontacts
    kcalendarcore
    ki18n
    zxing-cpp
  ];

  outputs = [
    "out"
    "dev"
  ];
}
