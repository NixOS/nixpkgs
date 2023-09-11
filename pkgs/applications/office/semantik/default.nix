{ stdenv
, lib
, mkDerivation
, fetchFromGitLab
, fetchpatch
, waf
, pkg-config
, cmake
, qtbase
, python3
, qtwebengine
, qtsvg
, ncurses6
, kio
, kauth
, kiconthemes
, kconfigwidgets
, kxmlgui
, kcoreaddons
, kconfig
, kwidgetsaddons
, ki18n
, sonnet
, kdelibs4support
}:

mkDerivation rec {
  pname = "semantik";
  version = "1.2.7";

  src = fetchFromGitLab {
    owner = "ita1024";
    repo = "semantik";
    rev = "semantik-${version}";
    sha256 = "sha256-aXOokji6fYTpaeI/IIV+5RnTE2Cm8X3WfADf4Uftkss=";
  };

  patches = [
    (fetchpatch {
      name = "fix-kdelibs4support.patch";
      url = "https://gitlab.com/ita1024/semantik/-/commit/a991265bd6e3ed6541f8ec099420bc08cc62e30c.patch";
      sha256 = "sha256-E4XjdWfUnqhmFJs9ORznHoXMDS9zHWNXvQIKKkN4AAo=";
    })
    ./qt5.patch
  ];

  postPatch = ''
    echo "${lib.getDev qtwebengine}"
    substituteInPlace wscript \
      --replace @Qt5Base_dev@ "${lib.getDev qtbase}" \
      --replace @KF5KIOCore_dev@ "${lib.getDev kio}" \
      --replace @KF5Auth_dev@ "${lib.getDev kauth}" \
      --replace @KF5IconThemes_dev@ "${lib.getDev kiconthemes}" \
      --replace @KF5ConfigWidgets_dev@ "${lib.getDev kconfigwidgets}" \
      --replace @KF5XmlGui_dev@ "${lib.getDev kxmlgui}" \
      --replace @KF5CoreAddons_dev@ "${lib.getDev kcoreaddons}" \
      --replace @KF5Config_dev@ "${lib.getDev kconfig}" \
      --replace @KF5WidgetsAddons_dev@ "${lib.getDev kwidgetsaddons}" \
      --replace @KF5I18n_dev@ "${lib.getDev ki18n}" \
      --replace @KF5SonnetUi_dev@ "${lib.getDev sonnet}" \
      --replace @Qt5Svg@ "${qtsvg}" \
      --replace @Qt5Svg_dev@ "${lib.getDev qtsvg}" \
      --replace @Qt5WebEngine@ "${qtwebengine}" \
      --replace @Qt5WebEngine_dev@ "${lib.getDev qtwebengine}" \
      --replace /usr/include/KF5/KDELibs4Support "${lib.getDev kdelibs4support}/include/KF5/KDELibs4Support"
  '';

  nativeBuildInputs = [ (lib.getDev qtsvg) (lib.getLib qtsvg) python3 pkg-config waf.hook cmake ];

  buildInputs = [
    qtbase
    qtwebengine
    qtsvg
    ncurses6
    kio
    kauth
    kiconthemes
    kconfigwidgets
    kxmlgui
    kcoreaddons
    kconfig
    kwidgetsaddons
    ki18n
    sonnet
    kdelibs4support
  ];

  wafConfigureFlags = [
    "--qtlibs=${lib.getLib qtbase}/lib"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A mind-mapping application for KDE";
    license = licenses.mit;
    homepage = "https://waf.io/semantik.html";
    maintainers = [ maintainers.shamilton ];
    platforms = platforms.linux;
  };
}
