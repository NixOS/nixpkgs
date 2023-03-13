{ mkDerivation
, lib
, extra-cmake-modules
, qtbase
, kactivities
, kross
, qtscript
, hunspell
, gettext
}:

mkDerivation rec {
  pname = "lokalize";

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ extra-cmake-modules ];

  propagatedBuildInputs = [
    kross
    qtscript
    hunspell
    kactivities
    qtbase
    gettext
  ];

  meta = with lib; {
    homepage = "https://apps.kde.org/lokalize/";
    description = "Computer-aided translation system that focuses on productivity and quality assurance";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ niknetniko ];
    broken = lib.versionOlder qtbase.version "5.15";
  };
}
