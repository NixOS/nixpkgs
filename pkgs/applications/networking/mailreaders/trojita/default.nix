{ akonadi-contacts
, cmake
, fetchgit
, gnupg
, gpgme
, kcontacts
, kf5gpgmepp
, lib
, libsecret
, mimetic
, mkDerivation
, pkgconfig
, qgpgme
, qtbase
, qtkeychain
, qttools
, qtwebkit
}:

mkDerivation rec {
  pname = "trojita";
  version = "0.7.20190618";

  src = fetchgit {
    url = "https://anongit.kde.org/trojita.git";
    rev = "90b417b131853553c94ff93aef62abaf301aa8f1";
    sha256 = "0xpxq5bzqaa68lkz90wima5q2m0mdcn0rvnigb66lylb4n20mnql";
  };

  buildInputs = [
    akonadi-contacts
    gpgme
    kcontacts
    libsecret
    mimetic
    qgpgme
    qtbase
    qtkeychain
    qtwebkit
    mimetic
    kf5gpgmepp
  ];

  nativeBuildInputs = [
    cmake
    pkgconfig
    qttools
    gnupg
  ];

  meta = with lib; {
    description = "A Qt IMAP e-mail client";
    homepage = "http://trojita.flaska.net/";
    license = with licenses; [ gpl2 gpl3 ];
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };

}
