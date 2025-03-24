{
  lib,
  mkDerivation,
  cmake,
  extra-cmake-modules,
  kconfig,
  kio,
  mauikit,
}:

mkDerivation {
  pname = "mauikit-filebrowsing";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kio
    mauikit
  ];

  meta = with lib; {
    homepage = "https://invent.kde.org/maui/mauikit-filebrowsing";
    description = "MauiKit File Browsing utilities and controls";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
