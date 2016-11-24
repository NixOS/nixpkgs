{ stdenv, fetchurl, cmake, gettext, pkgconfig, extra-cmake-modules, makeQtWrapper
, boost, subversion, apr, aprutil
, qtscript, qtwebkit, grantlee, karchive, kconfig, kcoreaddons, kguiaddons, kiconthemes, ki18n
, kitemmodels, kitemviews, kio, kparts, sonnet, kcmutils, knewstuff, knotifications
, knotifyconfig, ktexteditor, threadweaver, kdeclarative, libkomparediff2 }:

let
  pname = "kdevplatform";
  version = "5.0.2";
  dirVersion = "5.0.2";

in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  
  src = fetchurl {
    url = "mirror://kde/stable/kdevelop/${dirVersion}/src/${name}.tar.xz";
    sha256 = "a7f311198bb72f5fee064d99055e8df39ecf4e9066fe5c0ff901ee8c24d960ec";
  };

  nativeBuildInputs = [ cmake gettext pkgconfig extra-cmake-modules makeQtWrapper ];

  propagatedBuildInputs = [ ];
  buildInputs = [
    boost subversion apr aprutil
    qtscript qtwebkit grantlee karchive kconfig kcoreaddons kguiaddons kiconthemes
    ki18n kitemmodels kitemviews kio kparts sonnet kcmutils knewstuff
    knotifications knotifyconfig ktexteditor threadweaver kdeclarative
    libkomparediff2
  ];

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
