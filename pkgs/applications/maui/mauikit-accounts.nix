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
  pname = "mauikit-accounts";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kio
    mauikit
  ];

  meta = {
    homepage = "https://invent.kde.org/maui/mauikit-accounts";
    description = "MauiKit utilities to handle User Accounts";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ onny ];
  };
}
