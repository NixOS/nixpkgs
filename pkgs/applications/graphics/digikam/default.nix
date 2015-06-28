{ stdenv, fetchurl, automoc4, boost, shared_desktop_ontologies, cmake
, eigen, lcms, gettext, jasper, kdelibs, kdepimlibs, lensfun
, libgphoto2, libjpeg, libkdcraw, libkexiv2, libkipi, libpgf, libtiff
, libusb1, liblqr1, marble, mysql, opencv, phonon, pkgconfig, qca2
, qimageblitz, qjson, qt4, soprano
}:

stdenv.mkDerivation rec {
  name = "digikam-4.10.0";

  src = fetchurl {
    url = "http://download.kde.org/stable/digikam/${name}.tar.bz2";
    sha256 = "4207e68b6221307111b66bb69485d3e88150df95dae014a99f6f161a3da0c725";
  };

  nativeBuildInputs = [ cmake automoc4 pkgconfig ];

  buildInputs = [
    boost eigen gettext jasper kdelibs kdepimlibs lcms lensfun
    libgphoto2 libjpeg libkdcraw libkexiv2 libkipi liblqr1 libpgf
    libtiff marble mysql.lib opencv phonon qca2 qimageblitz qjson qt4
    shared_desktop_ontologies soprano
  ];

  # Make digikam find some FindXXXX.cmake
  KDEDIRS="${marble}:${qjson}";

  # Help digiKam find libusb, otherwise gphoto2 support is disabled
  cmakeFlags = "-DLIBUSB_LIBRARIES=${libusb1}/lib -DLIBUSB_INCLUDE_DIR=${libusb1}/include/libusb-1.0 -DDIGIKAMSC_COMPILE_LIBKFACE=ON";

  enableParallelBuilding = true;

  meta = {
    description = "Photo Management Program";
    license = stdenv.lib.licenses.gpl2;
    homepage = http://www.digikam.org;
    maintainers = with stdenv.lib.maintainers; [ goibhniu viric urkud ];
    inherit (kdelibs.meta) platforms;
  };
}
