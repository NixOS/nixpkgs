{
  mkDerivation, lib, fetchurl, extra-cmake-modules, kdoctools,
  boost, qttools, qtwebkit,
  breeze-icons, karchive, kcodecs, kcompletion, kconfig, kconfigwidgets, kcoreaddons,
  kcrash, kguiaddons, ki18n, kiconthemes, kitemviews, kio, ktexteditor, ktextwidgets,
  kwidgetsaddons, kxmlgui,
  kdb, kproperty, kreport, lcms2, libmysql, marble, postgresql
}:

mkDerivation rec {
  pname = "kexi";
  version = "3.0.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/src/${name}.tar.xz";
    sha256 = "1fjvjifi5ygx5gs2lzfg22j0x3r7kl4wk5jll09r8gc3dfxaiblf";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  buildInputs = [
    boost qttools qtwebkit
    breeze-icons karchive kcodecs kcompletion kconfig kconfigwidgets kcoreaddons
    kcrash kguiaddons ki18n kiconthemes kitemviews kio ktexteditor ktextwidgets
    kwidgetsaddons kxmlgui
    kdb kproperty kreport lcms2 libmysql marble postgresql
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
