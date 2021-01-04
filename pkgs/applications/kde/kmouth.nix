{ mkDerivation, lib, extra-cmake-modules, kdoctools, qtspeech, kxmlgui, kio }:

mkDerivation {
  name = "kmouth";
  meta = with lib; {
    homepage = "https://kde.org/applications/en/kmouth";
    description = "A program which enables persons that cannot speak to let their computer speak";
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
    kxmlgui
    qtspeech
  ];
}
