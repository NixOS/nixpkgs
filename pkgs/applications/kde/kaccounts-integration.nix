{
  mkDerivation,
  stdenv,
  extra-cmake-modules,
  kcmutils,
  kdoctools,
  libaccounts-glib,
  accounts-qt,
  signond,
  signon-plugin-oauth2,
  signon-ui,
  accounts-qml-module
}:

mkDerivation {

  name = "kaccounts-integration";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  buildInputs = [
    kcmutils
    libaccounts-glib
    accounts-qt
    signond
    signon-plugin-oauth2
    signon-ui
    accounts-qml-module
  ];

  meta = with stdenv.lib; {
    description = "Small system to administer web accounts for the sites and services across the KDE desktop";
    homepage = https://github.com/KDE/kaccounts-integration;
    platforms = platforms.linux;

    license = with licenses; [
      gpl2
      lgpl2.1
    ];

    maintainers = [ maintainers.konstantsky ];
  };

}
