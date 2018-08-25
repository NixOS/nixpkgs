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
  version = "3.1.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/src/${name}.tar.xz";
    sha256 = "1ysj44qq75wglw4d080l3gfw47695gapf29scxhb1g3py55csmbd";
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

  patches = [
    (fetchpatch {
      url = "https://phabricator.kde.org/file/data/6iwzltiifyqwjnzbvyo6/PHID-FILE-li4a7j35wkdkm2qdtnp4/D11503.diff";
      sha256 = "0yj717m4x1zb4xjy1ayhz78xkxpawxgsvjgvf5iw81jnlr8absq9";
    })
  ];

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
