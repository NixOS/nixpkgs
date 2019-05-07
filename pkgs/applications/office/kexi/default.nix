{
  mkDerivation, lib, fetchurl, fetchpatch, extra-cmake-modules, kdoctools,
  boost, qttools, qtwebkit,
  breeze-icons, karchive, kcodecs, kcompletion, kconfig, kconfigwidgets, kcoreaddons,
  kcrash, kguiaddons, ki18n, kiconthemes, kitemviews, kio, ktexteditor, ktextwidgets,
  kwidgetsaddons, kxmlgui,
  kdb, kproperty, kreport, lcms2, mysql, marble, postgresql
}:

mkDerivation rec {
  pname = "kexi";
  version = "3.2.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/src/${name}.tar.xz";
    sha256 = "1zy1q7q9rfdaws3rwf3my22ywkn6g747s3ixfcg9r80mm2g3z0bs";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  buildInputs = [
    boost qttools qtwebkit
    breeze-icons karchive kcodecs kcompletion kconfig kconfigwidgets kcoreaddons
    kcrash kguiaddons ki18n kiconthemes kitemviews kio ktexteditor ktextwidgets
    kwidgetsaddons kxmlgui
    kdb kproperty kreport lcms2 mysql.connector-c marble postgresql
  ];

  propagatedUserEnvPkgs = [ kproperty ];

  meta = with lib; {
    description = "A open source visual database applications creator, a long-awaited competitor for programs like MS Access or Filemaker";
    longDescription = ''
      Kexi is a visual database applications creator.
      It can be used for creating database schemas,
      inserting data, performing queries, and processing data.
      Forms can be created to provide a custom interface to your data.
      All database objects - tables, queries and forms - are stored in the database,
      making it easy to share data and design.
    '';
    homepage = http://kexi-project.org/;
    maintainers = with maintainers; [ zraexy ];
    platforms = platforms.linux;
    license = with licenses; [ gpl2 lgpl2 ];
  };
}
