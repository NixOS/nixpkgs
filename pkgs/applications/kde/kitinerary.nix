{ mkDerivation, lib, extra-cmake-modules
, qtdeclarative, ki18n, kmime, kpkpass
, poppler, kcontacts, kcalendarcore
, shared-mime-info
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
    qtdeclarative kmime kpkpass poppler
    kcontacts kcalendarcore
  ];

  CXXFLAGS = [
    "-I${lib.getDev ki18n}/include/KF5"  # Fixes: ki18n_version.h: No such file or directory
  ];

  outputs = [ "out" "dev" ];
}
