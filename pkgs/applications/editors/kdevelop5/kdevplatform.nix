{ stdenv, fetchurl, fetchpatch, cmake, gettext, pkgconfig, extra-cmake-modules
, boost, subversion, apr, aprutil, kwindowsystem
, qtscript, qtwebkit, grantlee, karchive, kconfig, kcoreaddons, kguiaddons, kiconthemes, ki18n
, kitemmodels, kitemviews, kio, kparts, sonnet, kcmutils, knewstuff, knotifications
, knotifyconfig, ktexteditor, threadweaver, kdeclarative, libkomparediff2 }:

let
  pname = "kdevplatform";
  version = "5.1.1";

in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/kdevelop/${version}/src/${name}.tar.xz";
    sha256 = "3159440512b1373c1a4b35f401ba1f81217de9578372b45137af141eeda6e726";
  };

  patches = [
    (fetchpatch {
      name = "kdevplatform-project-selection.patch";
      url = "https://cgit.kde.org/kdevplatform.git/patch/?id=da4c0fdfcf21dc2a8f48a2b1402213a32effd47a";
      sha256 = "16ws8l6dciy2civjnsaj03ml2bzvg4a9g7gd4iyx4hprw65zrcxm";
    })
  ];

  nativeBuildInputs = [ cmake gettext pkgconfig extra-cmake-modules ];

  buildInputs = [
    boost subversion apr aprutil kwindowsystem
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
