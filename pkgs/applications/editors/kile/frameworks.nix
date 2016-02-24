{ stdenv
, lib
, fetchgit
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, qtscript
, kconfig
, kcrash
, kdbusaddons
, kdelibs4support
, kguiaddons
, kiconthemes
, kinit
, khtml
, kparts
, ktexteditor
, kwindowsystem
, poppler
}:

stdenv.mkDerivation rec {
  name = "kile-${version}";
  version = "2016-02-14";

  src = fetchgit {
    url = git://anongit.kde.org/kile.git;
    rev = "7b238c42580abc936816d4ea0df61d0cbbefecc4";
    sha256 = "f37d531489a84911b47664697bb3bddc0ba5591854749c17fb0c6b1e71dbc6ee";

  };

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];

  buildInputs = [
    qtscript
    kconfig
    kcrash
    kdbusaddons
    kdelibs4support
    kdoctools
    kguiaddons
    kiconthemes
    kinit
    khtml
    kparts
    ktexteditor
    kwindowsystem
    poppler
  ];

  postInstall = ''
    wrapQtProgram "$out/bin/kile"
  '';

  meta = {
    description = "Kile is a user friendly TeX/LaTeX authoring tool for the KDE desktop environment";
    homepage = https://www.kde.org/applications/office/kile/;
    maintainers = with lib.maintainers; [ fridh ];
    license = lib.licenses.gpl2Plus;
  };
}
