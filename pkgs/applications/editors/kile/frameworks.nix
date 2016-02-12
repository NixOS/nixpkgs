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
  version = "2016-02-12";

  src = fetchgit {
    url = git://anongit.kde.org/kile.git;
    rev = "c586532031872319ae5102fb13ab6de8d80da065";
    sha256 = "7d5ef8b8c1254a5988a1028e415c9139fbd20a9e6771413c38fa58345a744a7b";

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
