{ mkDerivation, lib, extra-cmake-modules, kdoctools, kirigami2, qtquickcontrols2, qttools, qtgraphicaleffects }:

mkDerivation {
  name = "kirigami-gallery";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/kirigami2.gallery";
    description = "View examples of Kirigami components";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kirigami2
    qttools
    qtquickcontrols2
    qtgraphicaleffects
  ];
}
