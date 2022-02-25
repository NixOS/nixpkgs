{ mkDerivation, lib, extra-cmake-modules, kdoctools, ki18n, kio }:

mkDerivation {
  pname = "ktimer";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/utilities/org.kde.ktimer";
    description = "A little tool to execute programs after some time";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
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
