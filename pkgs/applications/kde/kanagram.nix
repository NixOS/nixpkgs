{ mkDerivation, lib, extra-cmake-modules, kdoctools, kdeclarative, knewstuff, libkeduvocdocument, kdeedu-data }:

mkDerivation {
  name = "kanagram";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/kanagram";
    description = "Game based on anagrams of words";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdeclarative
    kdoctools
    knewstuff
    libkeduvocdocument
  ];

  preFixup = ''
    qtWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${kdeedu-data}/share"
    )
  '';
}
