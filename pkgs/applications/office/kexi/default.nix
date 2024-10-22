{
  mkDerivation, lib, fetchurl, fetchpatch, extra-cmake-modules, kdoctools,
  boost, qttools, qtwebkit,
  breeze-icons, karchive, kcodecs, kcompletion, kconfig, kconfigwidgets, kcoreaddons,
  kcrash, kguiaddons, ki18n, kiconthemes, kitemviews, kio, ktexteditor, ktextwidgets,
  kwidgetsaddons, kxmlgui,
  kdb, kproperty, kreport, lcms2, libmysqlclient, marble, postgresql
}:

mkDerivation rec {
  pname = "kexi";
  version = "3.2.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/src/${pname}-${version}.tar.xz";
    sha256 = "1zy1q7q9rfdaws3rwf3my22ywkn6g747s3ixfcg9r80mm2g3z0bs";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  buildInputs = [
    boost qttools qtwebkit
    breeze-icons karchive kcodecs kcompletion kconfig kconfigwidgets kcoreaddons
    kcrash kguiaddons ki18n kiconthemes kitemviews kio ktexteditor ktextwidgets
    kwidgetsaddons kxmlgui
    kdb kproperty kreport lcms2 libmysqlclient marble postgresql
  ];

  propagatedUserEnvPkgs = [ kproperty ];

  patches = [
    # Changes in Qt 5.13 mean that QDate isn't exported from certain places,
    # which the build was relying on. This patch explicitly imports QDate where
    # needed.
    # Should be unnecessary with kexi >= 3.3
    (fetchpatch {
      url = "https://cgit.kde.org/kexi.git/patch/src/plugins/forms/widgets/kexidbdatepicker.cpp?id=511d99b7745a6ce87a208bdbf69e631f1f136d53";
      sha256 = "0m5cwq2v46gb1b12p7acck6dadvn7sw4xf8lkqikj9hvzq3r1dnj";
    })
  ];

  meta = with lib; {
    description = "Open source visual database applications creator, a long-awaited competitor for programs like MS Access or Filemaker";
    longDescription = ''
      Kexi is a visual database applications creator.
      It can be used for creating database schemas,
      inserting data, performing queries, and processing data.
      Forms can be created to provide a custom interface to your data.
      All database objects - tables, queries and forms - are stored in the database,
      making it easy to share data and design.
    '';
    homepage = "https://kexi-project.org/";
    maintainers = with maintainers; [ zraexy ];
    platforms = platforms.linux;
    license = with licenses; [ gpl2 lgpl2 ];
  };
}
