{ mkDerivation, lib, extra-cmake-modules, kconfig, ki18n, kservice, kxmlgui }:

mkDerivation {
  pname = "libkipi";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kconfig ki18n kservice kxmlgui ];
  outputs = [ "out" "dev" ];
}
