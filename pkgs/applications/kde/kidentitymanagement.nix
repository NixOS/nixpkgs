{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  kcompletion, kcoreaddons, kemoticons, kiconthemes, kio, kpimtextedit,
  ktextwidgets, kxmlgui
}:

mkDerivation {
  pname = "kidentitymanagement";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcompletion kemoticons kiconthemes kio ktextwidgets kxmlgui
  ];
  propagatedBuildInputs = [ kcoreaddons kpimtextedit ];
  outputs = [ "out" "dev" ];
}
