{ mkDerivation, lib, fetchurl, cmake, gettext, pkgconfig, extra-cmake-modules
, qtquickcontrols, qtwebkit, qttools, kde-cli-tools, qtbase
, kconfig, kdeclarative, kdoctools, kiconthemes, ki18n, kitemmodels, kitemviews
, kjobwidgets, kcmutils, kio, knewstuff, knotifyconfig, kparts, ktexteditor
, threadweaver, kxmlgui, kwindowsystem, grantlee, kcrash, karchive, kguiaddons
, plasma-framework, krunner, kdevelop-pg-qt, shared-mime-info, libkomparediff2
, libksysguard, konsole, llvmPackages, makeWrapper, kpurpose, boost
}:

let
  pname = "kdevelop";
  version = "5.3.1";
  qtVersion = "5.${lib.versions.minor qtbase.version}";
in
mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "1098ra7qpal6578hsv20kvxc63v47sp85wjhqr5rgzr2fm7jf6fr";
  };

  nativeBuildInputs = [
    cmake gettext pkgconfig extra-cmake-modules makeWrapper
  ];

  buildInputs = [
    kdevelop-pg-qt
    llvmPackages.llvm llvmPackages.clang-unwrapped
  ];

  propagatedBuildInputs = [
    qtquickcontrols qtwebkit boost libkomparediff2
    kconfig kdeclarative kdoctools kiconthemes ki18n kitemmodels kitemviews
    kjobwidgets kcmutils kio knewstuff knotifyconfig kparts ktexteditor
    threadweaver kxmlgui kwindowsystem grantlee plasma-framework krunner
    shared-mime-info libksysguard konsole kcrash karchive kguiaddons kpurpose
  ];

  # https://cgit.kde.org/kdevelop.git/commit/?id=716372ae2e8dff9c51e94d33443536786e4bd85b
  # required as nixos seems to be unable to find CLANG_BUILTIN_DIR
  cmakeFlags = [
    "-DCLANG_BUILTIN_DIR=${llvmPackages.clang-unwrapped}/lib/clang/${(builtins.parseDrvName llvmPackages.clang.name).version}/include"
  ];

  postInstall = ''
    # The kdevelop! script (shell environment) needs qdbus and kioclient5 in PATH.
    wrapProgram "$out/bin/kdevelop!" \
      --prefix PATH ":" "${lib.makeBinPath [ qttools kde-cli-tools ]}"

    wrapProgram "$out/bin/kdevelop" \
      --prefix QT_PLUGIN_PATH : $out/lib/qt-${qtVersion}/plugins

    # Fix the (now wrapped) kdevelop! to find things in right places:
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
