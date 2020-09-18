{ mkDerivation, lib, extra-cmake-modules }:

mkDerivation {
  name = "kdeedu-data";
  meta = with lib; {
    homepage = "https://edu.kde.org/";
    description = "Data for KDEEdu applications";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
}
