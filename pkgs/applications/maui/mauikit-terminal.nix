{
  lib,
  mkDerivation,
  cmake,
  extra-cmake-modules,
  kconfig,
  kcoreaddons,
  ki18n,
  mauikit,
}:

mkDerivation {
  pname = "mauikit-terminal";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kcoreaddons
    ki18n
    mauikit
  ];

  meta = with lib; {
    homepage = "https://invent.kde.org/maui/mauikit-terminal";
    description = "Terminal support components for Maui applications";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
