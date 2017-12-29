{ stdenv, fetchurl, cmake, gettext, pkgconfig, extra-cmake-modules
, boost, subversion, apr, aprutil, kwindowsystem
, qtscript, qtwebkit, grantlee, karchive, kconfig, kcoreaddons, kguiaddons, kiconthemes, ki18n
, kitemmodels, kitemviews, kio, kparts, sonnet, kcmutils, knewstuff, knotifications
, knotifyconfig, ktexteditor, threadweaver, kdeclarative, libkomparediff2 }:

let
  pname = "kdevplatform";
  version = "5.1.2";

in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/kdevelop/${version}/src/${name}.tar.xz";
    sha256 = "e622ddad552a678baaf1166d5cbdc5fd1192d2324300c52ef2d25f1c6778664a";
  };

  nativeBuildInputs = [ cmake gettext pkgconfig extra-cmake-modules ];

  buildInputs = [
    boost subversion apr aprutil kwindowsystem
    qtscript qtwebkit grantlee karchive kconfig kcoreaddons kguiaddons kiconthemes
    ki18n kitemmodels kitemviews kio kparts sonnet kcmutils knewstuff
    knotifications knotifyconfig ktexteditor threadweaver kdeclarative
    libkomparediff2
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    maintainers = [ maintainers.ambrop72 ];
    platforms = platforms.linux;
    description = "KDE libraries for IDE-like programs";
    longDescription = ''
      A free, opensource set of libraries that can be used as a foundation for
      IDE-like programs. It is programing-language independent, and is planned
      to be used by programs like: KDevelop, Quanta, Kile, KTechLab ... etc."
    '';
    homepage = https://www.kdevelop.org;
    license = with stdenv.lib.licenses; [ gpl2Plus lgpl2Plus ];
  };
}
