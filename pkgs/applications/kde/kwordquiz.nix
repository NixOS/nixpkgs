{ mkDerivation, lib, extra-cmake-modules, kdoctools, knewstuff, kxmlgui, knotifyconfig, libkeduvocdocument, kdeedu-data, phonon }:

mkDerivation {
  name = "kwordquiz";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/kwordquiz";
    description = "A general purpose flash card program";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    knewstuff
    knotifyconfig
    kxmlgui
    libkeduvocdocument
    phonon
  ];

  preFixup = ''
    qtWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${kdeedu-data}/share"
    )
  '';
}
