{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  boost,
  karchive,
  kcrash,
  kiconthemes,
  kparts,
  ktexteditor,
  qtsvg,
  qtxmlpatterns,
}:

mkDerivation {
  pname = "kig";
  meta = with lib; {
    homepage = "https://apps.kde.org/kig/";
    description = "Interactive geometry";
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ raskin ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    boost
    karchive
    kcrash
    kiconthemes
    kparts
    ktexteditor
    qtsvg
    qtxmlpatterns
  ];
}
