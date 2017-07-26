{
  mkDerivation, lib, extra-cmake-modules, kdoctools, shared_mime_info,
  exiv2, kactivities, karchive, kbookmarks, kconfig, kconfigwidgets,
  kcoreaddons, kdbusaddons, kguiaddons, kdnssd, kiconthemes, ki18n, kio, khtml,
  kdelibs4support, kpty, libmtp, libssh, openexr, ilmbase, openslp, phonon,
  qtsvg, samba, solid
}:

mkDerivation {
  name = "kio-extras";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools shared_mime_info ];
  propagatedBuildInputs = [
    exiv2 kactivities karchive kbookmarks kconfig kconfigwidgets kcoreaddons
    kdbusaddons kguiaddons kdnssd kiconthemes ki18n kio khtml kdelibs4support
    kpty libmtp libssh openexr openslp phonon qtsvg samba solid
  ];
  NIX_CFLAGS_COMPILE = [ "-I${ilmbase.dev}/include/OpenEXR" ];
}
