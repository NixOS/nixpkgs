{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kconfig,
  ki18n,
  kservice,
  kxmlgui,
}:

mkDerivation {
  pname = "libkipi";
  meta = with lib; {
    license = with licenses; [
      gpl2
      lgpl21
      bsd3
    ];
    maintainers = [ maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kconfig
    ki18n
    kservice
    kxmlgui
  ];
  outputs = [
    "out"
    "dev"
  ];
}
