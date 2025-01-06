{
  lib,
  mkDerivation,
  cmake,
  extra-cmake-modules,
  kconfig,
  kio,
  mauikit,
  syntax-highlighting,
}:

mkDerivation {
  pname = "mauikit-texteditor";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kio
    mauikit
    syntax-highlighting
  ];

  meta = {
    homepage = "https://invent.kde.org/maui/mauikit-texteditor";
    description = "MauiKit Text Editor components";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ onny ];
  };
}
