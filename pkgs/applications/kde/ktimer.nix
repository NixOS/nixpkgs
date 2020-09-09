{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio }:

mkDerivation {
  name = "ktimer";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/utilities/org.kde.ktimer";
    description = "KTimer is a little tool to execute programs after some time";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    ki18n
    kio
  ];
}
