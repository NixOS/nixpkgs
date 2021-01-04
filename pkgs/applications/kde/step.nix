{ mkDerivation, lib, extra-cmake-modules, kdoctools, knewstuff, kplotting, eigen, libqalculate, shared-mime-info, python3 }:

mkDerivation {
  name = "step";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/step";
    description = "Interactive physical simulator";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };

  preConfigure = ''
    patchShebangs .
  '';
  nativeBuildInputs = [
    extra-cmake-modules
    python3
  ];
  buildInputs = [
    eigen
    shared-mime-info
    kdoctools
    knewstuff
    kplotting
    libqalculate
  ];
}
