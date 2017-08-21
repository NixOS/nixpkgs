{ mkDerivation, lib, fetchurl, cmake, gettext, pkgconfig, extra-cmake-modules
, qtquickcontrols, qtwebkit, qttools, kde-cli-tools
, kconfig, kdeclarative, kdoctools, kiconthemes, ki18n, kitemmodels, kitemviews
, kjobwidgets, kcmutils, kio, knewstuff, knotifyconfig, kparts, ktexteditor
, threadweaver, kxmlgui, kwindowsystem, grantlee
, plasma-framework, krunner, kdevplatform, kdevelop-pg-qt, shared_mime_info
, libksysguard, konsole, llvmPackages, makeWrapper
}:

let
  pname = "kdevelop";
  version = "5.1.1";

in
mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "0a01a4ffb2f01802cf4945521a3149a8f82c21fa8a97935991f1854b7db5d754";
  };

  nativeBuildInputs = [
    cmake gettext pkgconfig extra-cmake-modules makeWrapper
  ];

  buildInputs = [
    kdevelop-pg-qt
    llvmPackages.llvm llvmPackages.clang-unwrapped
  ];

  propagatedBuildInputs = [
    qtquickcontrols qtwebkit
    kconfig kdeclarative kdoctools kiconthemes ki18n kitemmodels kitemviews
    kjobwidgets kcmutils kio knewstuff knotifyconfig kparts ktexteditor
    threadweaver kxmlgui kwindowsystem grantlee plasma-framework krunner
    kdevplatform shared_mime_info libksysguard konsole
  ];

  postInstall = ''
    # The kdevelop! script (shell environment) needs qdbus and kioclient5 in PATH.
    wrapProgram "$out/bin/kdevelop!" --prefix PATH ":" "${qttools}/bin:${kde-cli-tools}/bin"

    # Fix the (now wrapped) kdevelop! to find things in right places:
    # - Make KDEV_BASEDIR point to bin directory of kdevplatform.
    kdev_fixup_sed="s|^export KDEV_BASEDIR=.*$|export KDEV_BASEDIR=${kdevplatform}/bin|"
    # - Fixup the one use where KDEV_BASEDIR is assumed to contain kdevelop.
    kdev_fixup_sed+=";s|\\\$KDEV_BASEDIR/kdevelop|$out/bin/kdevelop|"
    sed -E -i "$kdev_fixup_sed" "$out/bin/.kdevelop!-wrapped"
  '';

  meta = with lib; {
    maintainers = [ maintainers.ambrop72 ];
    platforms = platforms.linux;
    description = "KDE official IDE";
    longDescription =
      ''
        A free, opensource IDE (Integrated Development Environment)
        for MS Windows, Mac OsX, Linux, Solaris and FreeBSD. It is a
        feature-full, plugin extendable IDE for C/C++ and other
        programing languages. It is based on KDevPlatform, KDE and Qt
        libraries and is under development since 1998.
      '';
    homepage = https://www.kdevelop.org;
    license = with licenses; [ gpl2Plus lgpl2Plus ];
  };
}
