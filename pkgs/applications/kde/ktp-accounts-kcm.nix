{
  mkDerivation,
  stdenv,
  extra-cmake-modules,
  kcmutils,
  kdoctools,
  kaccounts-integration,
  kaccounts-providers,
  accounts-qt,
  signond,
  signon-plugin-oauth2,
  libaccounts-glib,
  intltool,
  telepathy
}:

mkDerivation {

  name = "ktp-accounts-kcm";

  nativeBuildInputs = [
    extra-cmake-modules
  ];

  buildInputs = [
    kdoctools
    kcmutils
    telepathy
    kaccounts-integration
    kaccounts-providers
    accounts-qt
    signond
    signon-plugin-oauth2
    libaccounts-glib
    intltool
  ];

  meta = with stdenv.lib; {
    description = "KDE providers for integration with online services and sites.";
    homepage = https://github.com/KDE/kaccounts-providers;
    platforms = platforms.linux;

    license = with licenses; [
      gpl2
    ];

    maintainers = [ maintainers.konstantsky ];
  };

}
