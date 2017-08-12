{ mkDerivation, lib, fetchpatch
, automoc4, bison, cmake, flex, libxslt, perl, pkgconfig, shared_mime_info
, attica, attr, avahi, docbook_xml_dtd_42, docbook_xsl, giflib, ilmbase
, libdbusmenu_qt, libjpeg, libxml2, phonon, polkit_qt4, qca2, qt4
, shared_desktop_ontologies, soprano, strigi, udev, xz, pcre, openssl
}:

mkDerivation {
  name = "kdelibs";

  outputs = [ "out" "dev" ];

  outputInclude = "out";

  setOutputFlags = false;

  nativeBuildInputs = [
    automoc4 bison cmake flex libxslt perl pkgconfig shared_mime_info
  ];
  buildInputs = [
    openssl attica attr avahi giflib libdbusmenu_qt libjpeg libxml2
    polkit_qt4 qca2 shared_desktop_ontologies udev xz pcre
  ];
  propagatedBuildInputs = [ qt4 soprano phonon strigi ];

  patches = [
    ./0001-old-kde4-cmake-policies.patch
    ./0002-polkit-install-path.patch
    ./0003-remove_xdg_impurities.patch
    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinuxarm/PKGBUILDs/39bcd80edc68a536b1c466f35933041e3790e0e7/extra/kdelibs/kdelibs-openssl-1.1.patch";
      sha256 = "0bmwyqmml7bqnxys95wgfrxz6qm7w132hydihxx2qjv9gyhgkqhr";
    })
  ];

  # cmake does not detect path to `ilmbase`
  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";

  cmakeFlags = [
    "-DDOCBOOKXML_CURRENTDTD_DIR=${docbook_xml_dtd_42}/xml/dtd/docbook"
    "-DDOCBOOKXSL_DIR=${docbook_xsl}/xml/xsl/docbook"
    "-DWITH_SOLID_UDISKS2=ON"
    "-DKDE_DEFAULT_HOME=.kde"
  ];

  meta = {
    platforms = lib.platforms.linux;
    homepage = http://www.kde.org;
    license = with lib.licenses; [ gpl2 fdl12 lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
