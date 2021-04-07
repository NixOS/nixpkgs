{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  grantlee, kcodecs, kconfigwidgets, kemoticons, ki18n, kiconthemes, kio,
  kdesignerplugin, ktextwidgets, sonnet, syntax-highlighting, qtbase, qttools,
  qtspeech
}:

mkDerivation {
  pname = "kpimtextedit";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
    broken = lib.versionOlder qtbase.version "5.13.0";
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    grantlee kcodecs kconfigwidgets kemoticons ki18n kiconthemes kio kdesignerplugin
    sonnet syntax-highlighting qttools qtspeech
  ];
  propagatedBuildInputs = [ ktextwidgets ];
  outputs = [ "out" "dev" ];
}
