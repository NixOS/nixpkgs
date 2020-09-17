{ mkDerivation, lib, extra-cmake-modules, kdoctools, qtmultimedia, qtwebengine, kconfig, knewstuff, kcmutils, kross, libkeduvocdocument, kdeedu-data }:

mkDerivation {
  name = "parley";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/parley";
    description = "A vocabulary trainer";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kconfig
    kcmutils
    kdoctools
    knewstuff
    kross
    qtmultimedia
    qtwebengine
    libkeduvocdocument
  ];

  preFixup = ''
    qtWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${kdeedu-data}/share"
    )
  '';
}
