{ mkDerivation, fetchpatch, lib, extra-cmake-modules
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

  patches = [
    # Fix build with poppler 22.03
    (fetchpatch {
      url = "https://github.com/KDE/kitinerary/commit/e21d1ffc5fa81a636245f49c97fe7cda63abbb1d.patch";
      sha256 = "1/zgq9QIOCPplqplDqgpoqzuYFf/m1Ixxawe50t2F04=";
    })
  ];

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
