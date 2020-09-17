{ mkDerivation, lib, extra-cmake-modules, kdoctools, kconfig, kio }:

mkDerivation {
  name = "kcron";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/kcron";
    description = "Graphical front end to the standard \"cron\" utility";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kconfig
    kio
  ];
}
