{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kio, kparts, kwindowsystem
}:

mkDerivation {
  name = "keditbookmarks";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kio kparts kwindowsystem ];
  meta = with lib; {
    homepage = http://www.kde.org;
    license = with licenses; [ gpl2 lgpl21 fdl12 bsd3 ];
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
