{ mkDerivation, lib, extra-cmake-modules, kdoctools, kio }:

mkDerivation {
  name = "kdesdk-kioslaves";
  meta = with lib; {
    homepage = "https://invent.kde.org/sdk/kdesdk-kioslaves";
    description = "KIO Slaves useful for software development";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kio
  ];
}
