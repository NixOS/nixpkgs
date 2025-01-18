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
  meta = with lib; {
    license = with licenses; [ lgpl21 ];
    maintainers = [ maintainers.bkchr ];
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
