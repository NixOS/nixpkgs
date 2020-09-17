{ mkDerivation, lib, extra-cmake-modules, kdoctools, solid, kcoreaddons, phonon }:

mkDerivation {
  name = "libkcompactdisc";
  meta = with lib; {
    homepage = "https://github.com/kde/libkcompactdisc";
    description = "Library for interfacing with CDs";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  outputs = [ "out" "dev" ];
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kcoreaddons
    solid
  ];
  propagatedBuildInputs = [
    phonon
  ];
}
