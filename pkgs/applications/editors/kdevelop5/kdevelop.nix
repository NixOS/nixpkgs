{ stdenv, fetchurl, cmake, gettext, pkgconfig, extra-cmake-modules, makeQtWrapper
, qtquickcontrols, qtwebkit, qttools
, kconfig, kdeclarative, kdoctools, kiconthemes, ki18n, kitemmodels, kitemviews
, kjobwidgets, kcmutils, kio, knewstuff, knotifyconfig, kparts, ktexteditor
, threadweaver, kxmlgui, kwindowsystem, grantlee
, plasma-framework, krunner, kdevplatform, kdevelop-pg-qt, shared_mime_info
, libksysguard, konsole, llvmPackages, makeWrapper
}:

let
  pname = "kdevelop";
  version = "5.0.4";
  dirVersion = "5.0.4";

in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${dirVersion}/src/${name}.tar.xz";
    sha256 = "191142b2bdb14837c82721fdfeb15e852329f2c4c0d48fd479c57514c3235d55";
  };

  nativeBuildInputs = [
    cmake gettext pkgconfig extra-cmake-modules makeWrapper makeQtWrapper
  ];

  buildInputs = [
    qtquickcontrols qtwebkit
    kconfig kdeclarative kdoctools kiconthemes ki18n kitemmodels kitemviews
    kjobwidgets kcmutils kio knewstuff knotifyconfig kparts ktexteditor
    threadweaver kxmlgui kwindowsystem grantlee plasma-framework krunner
    kdevplatform kdevelop-pg-qt shared_mime_info libksysguard konsole.unwrapped
    llvmPackages.llvm llvmPackages.clang-unwrapped
  ];

  postInstall = ''
    wrapQtProgram "$out/bin/kdevelop"
    wrapProgram "$out/bin/kdevelop!" --prefix PATH ":" "${qttools}/bin"
  '';

  meta = with stdenv.lib; {
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
    license = with stdenv.lib.licenses; [ gpl2Plus lgpl2Plus ];
  };
}
