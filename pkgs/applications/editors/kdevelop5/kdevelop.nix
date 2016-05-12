{ stdenv, fetchurl, cmake, gettext, pkgconfig, extra-cmake-modules, makeQtWrapper
, qtquick1, qtquickcontrols
, kconfig, kdeclarative, kdoctools, kiconthemes, ki18n, kitemmodels, kitemviews
, kjobwidgets, kcmutils, kio, knewstuff, knotifyconfig, kparts, ktexteditor
, threadweaver, kxmlgui, kwindowsystem
, plasma-framework, krunner, kdevplatform, kdevelop-pg-qt, shared_mime_info
, libksysguard, okteta, llvmPackages
}:

let
  pname = "kdevelop";
  version = "4.90.91";

in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/unstable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "eb807fc6425ff5454c2e4c93a46b80394cf38055770aade50593dce22731d749";
  };

  nativeBuildInputs = [ cmake gettext pkgconfig extra-cmake-modules makeQtWrapper ];

  buildInputs = [
    qtquick1 qtquickcontrols
    kconfig kdeclarative kdoctools kiconthemes ki18n kitemmodels kitemviews
    kjobwidgets kcmutils kio knewstuff knotifyconfig kparts ktexteditor
    threadweaver kxmlgui kwindowsystem plasma-framework krunner
    kdevplatform kdevelop-pg-qt shared_mime_info libksysguard okteta
    llvmPackages.llvm llvmPackages.clang-unwrapped
  ];

  postInstall = ''
    wrapQtProgram "$out/bin/kdevelop"
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
  };
}
