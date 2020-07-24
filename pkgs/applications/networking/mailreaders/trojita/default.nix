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
  version = "0.7.20200706";

  src = fetchgit {
    url = "https://anongit.kde.org/trojita.git";
    rev = "e973a5169f18ca862ceb8ad749c93cd621d86e14";
    sha256 = "0r8nmlqwgsqkk0k8xh32fkwvv6iylj35xq2h8b7l3g03yc342kbn";
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
