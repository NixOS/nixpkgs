{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  grantlee5, kcodecs, kconfigwidgets, kemoticons, ki18n, kiconthemes, kio,
  kdesignerplugin, ktextwidgets, sonnet, syntax-highlighting, qttools,
}:

mkDerivation {
  name = "kpimtextedit";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    grantlee5 kcodecs kconfigwidgets kemoticons ki18n kiconthemes kio kdesignerplugin
    sonnet syntax-highlighting qttools
  ];
  propagatedBuildInputs = [ ktextwidgets ];
  outputs = [ "out" "dev" ];
}
