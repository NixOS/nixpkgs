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
  version = "2016-07-02";

  src = fetchgit {
    url = git://anongit.kde.org/kile.git;
    rev = "d38bc7069667119cc891b351188484ca6fb88973";
    sha256 = "1nha71i16fs7nq2812b5565nbmbsbs3ak5czas6xg1dg5bsvdqh8";

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
