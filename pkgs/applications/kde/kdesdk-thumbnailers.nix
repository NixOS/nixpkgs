{ mkDerivation, lib, extra-cmake-modules, kdoctools, kconfig, kio }:

mkDerivation {
  name = "kdesdk-thumbnailers";
  meta = with lib; {
    homepage = "https://invent.kde.org/sdk/kdesdk-thumbnailers";
    description = "Plugins for the thumbnailing system";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kconfig
    kdoctools
    kio
  ];
}
