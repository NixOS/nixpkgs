{
  mkDerivation,
  lib,
  extra-cmake-modules,
  gettext,
  kdoctools,
  karchive,
  kconfig,
  kio,
}:

mkDerivation {
  pname = "ksystemlog";

  nativeBuildInputs = [
    extra-cmake-modules
    gettext
    kdoctools
  ];
  propagatedBuildInputs = [
    karchive
    kconfig
    kio
  ];

  meta = with lib; {
    homepage = "https://apps.kde.org/ksystemlog/";
    description = "System log viewer";
    mainProgram = "ksystemlog";
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ peterhoeg ];
  };
}
