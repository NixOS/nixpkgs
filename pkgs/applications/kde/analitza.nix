{ mkDerivation, lib, extra-cmake-modules, kdoctools, eigen, qttools }:

mkDerivation {
  name = "analitza";
  meta = with lib; {
    description = "KDE Mathematical library";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    eigen
    qttools
  ];
}
