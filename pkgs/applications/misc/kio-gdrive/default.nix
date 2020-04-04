{
  mkDerivation,
  stdenv,
  fetchurl,
  extra-cmake-modules,
  kdoctools,
  shared-mime-info,
  libkgapi,
  accounts-qt,
  kaccounts-integration,
  kaccounts-providers,
  intltool,
  kcontacts,
  kio,
  kcalendarcore,
  qtkeychain,
  signon-ui,
  signond,
  libaccounts-glib,
  libsecret
}:

stdenv.mkDerivation rec {

  name = "kio-gdrive";

  version = "1.2.7";
  src = fetchurl {
    url = "mirror://kde/stable/kio-gdrive/${version}/src/kio-gdrive-${version}.tar.xz";
    sha256 = "1b59e4d9940deb290cc4d7441d4ae8762ccb1de8d14dbd0bdbd3bc9a5fc266a4";
    name = "kio-gdrive-${version}.tar.xz";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    shared-mime-info
    libsecret
    libaccounts-glib
  ];

  buildInputs = [
    libkgapi
    kaccounts-integration
    kaccounts-providers
    accounts-qt
    intltool
    kcontacts
    qtkeychain
    kio
    signon-ui
    signond
    kcalendarcore
  ];

  meta = with stdenv.lib; {
    description = "A KIO slave that enables KIO-aware applications to access and edit Google Drive files on the cloud";
    homepage = https://community.kde.org/KIO_GDrive;
    platforms = platforms.linux;

    license = with licenses; [
      gpl2
      gpl3
    ];

    maintainers = [ maintainers.konstantsky ];
  };

}
