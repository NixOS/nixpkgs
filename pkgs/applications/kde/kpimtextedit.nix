{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  grantlee, kcodecs, kconfigwidgets, kemoticons, ki18n, kiconthemes, kio,
  kdesignerplugin, ktextwidgets, sonnet, syntax-highlighting, qttools,
  qtspeech
}:

mkDerivation {
  pname = "kpimtextedit";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    grantlee kcodecs kconfigwidgets kemoticons ki18n kiconthemes kio kdesignerplugin
    sonnet syntax-highlighting qttools qtspeech
  ];
  propagatedBuildInputs = [ ktextwidgets ];
  outputs = [ "out" "dev" ];
  postInstall = ''
    # added as an include directory by cmake files and fails to compile if it's missing
    mkdir -p "$dev/include/KF5"
  '';
}
