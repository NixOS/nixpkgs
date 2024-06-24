{ mkDerivation
, lib
, extra-cmake-modules
, cmake
, karchive
, ki18n
, kiconthemes
, kdelibs4support
, ktexteditor
}:

mkDerivation {
  pname = "umbrello";
  meta = {
    homepage = "https://umbrello.kde.org/";
    description = "Unified Modelling Language (UML) diagram program";
    license = [ lib.licenses.gpl2 ];
  };
  nativeBuildInputs = [
    cmake extra-cmake-modules
  ];
  propagatedBuildInputs = [
    karchive ki18n kiconthemes kdelibs4support ktexteditor
  ];
}
