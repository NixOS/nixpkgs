{ mkDerivation, lib, extra-cmake-modules, kdoctools
, breeze-icons, karchive, kconfig, kcrash, kdbusaddons, ki18n
, kiconthemes, kitemmodels, khtml, kio, kparts, kpty, kservice, kwidgetsaddons
, libarchive, libzip
# Archive tools
, p7zip, lrzip, unar
# Unfree tools
, unfreeEnableUnrar ? false, unrar
}:

let
  extraTools = [ p7zip lrzip unar ] ++ lib.optional unfreeEnableUnrar unrar;
in

mkDerivation {
  pname = "ark";

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  buildInputs = [ libarchive libzip ] ++ extraTools;

  propagatedBuildInputs = [
    breeze-icons karchive kconfig kcrash kdbusaddons khtml ki18n kiconthemes kio
    kitemmodels kparts kpty kservice kwidgetsaddons
  ];

  qtWrapperArgs = [ "--prefix" "PATH" ":" (lib.makeBinPath extraTools) ];

  meta = with lib; {
    homepage = "https://apps.kde.org/ark/";
    description = "Graphical file compression/decompression utility";
    license = with licenses; [ gpl2 lgpl3 ] ++ optional unfreeEnableUnrar unfree;
    maintainers = [ maintainers.ttuegel ];
  };
}
