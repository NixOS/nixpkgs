{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  akonadi, karchive, kcompletion, kiconthemes, kidentitymanagement, kio,
  kmailtransport, knewstuff, kwindowsystem, kxmlgui, libkdepim, pimcommon,
  qtwebengine, syntax-highlighting,
}:

mkDerivation {
  name = "libksieve";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = kdepimTeam;
  };
  outputs = [ "out" "dev" ];
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    akonadi karchive kcompletion kiconthemes kidentitymanagement kio
    kmailtransport knewstuff kwindowsystem kxmlgui libkdepim pimcommon
    qtwebengine
  ];
  propagatedBuildInputs = [ syntax-highlighting ];
}
