{ mkDerivation, lib, extra-cmake-modules, kdoctools, kdeclarative, knewstuff, kxmlgui, libkeduvocdocument, kdeedu-data }:

mkDerivation {
  name = "khangman";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/khangman";
    description = "Game based on the well-known hangman game";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdoctools
    kdeclarative
    knewstuff
    kxmlgui
    libkeduvocdocument
  ];

  preFixup = ''
    qtWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${kdeedu-data}/share"
    )
  '';
}
