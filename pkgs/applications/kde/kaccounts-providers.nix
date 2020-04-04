{
  mkDerivation,
  stdenv,
  extra-cmake-modules,
  kaccounts-integration,
  intltool,
  accounts-qt,
  signond,
  signon-plugin-oauth2,
  libaccounts-glib,
  kconfigwidgets,
  kiconthemes,
  kdeclarative,
  qtdeclarative,
  kdoctools,
  kio
}:

mkDerivation {

  name = "kaccounts-providers";

  nativeBuildInputs = [
    extra-cmake-modules
    intltool
  ];

  buildInputs = [
    kaccounts-integration
    accounts-qt
    signond
    signon-plugin-oauth2
    libaccounts-glib
    kconfigwidgets
    kiconthemes
    qtdeclarative
    kdoctools
    kio
    kdeclarative
  ];

  meta = with stdenv.lib; {
    description = "KDE providers for integration with online services and sites";
    homepage = https://github.com/KDE/kaccounts-providers;
    platforms = platforms.linux;

    license = with licenses; [
      gpl2
    ];
    maintainers = [ maintainers.konstantsky ];
  };

}
