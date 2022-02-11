{ akonadi-contacts
, cmake
, fetchgit
, fetchsvn
, gnupg
, gpgme
, kcontacts
, kf5gpgmepp
, lib
, libsecret
, mimetic
, mkDerivation
, pkg-config
, qgpgme
, qtbase
, qtkeychain
, qttools
, qtwebkit
, qttranslations
, substituteAll
, withI18n ? false
}:

let
  l10n = fetchsvn {
    url = "svn://anonsvn.kde.org/home/kde/trunk/l10n-kf5";
    rev = "1566642";
    sha256 = "0y45fjib153za085la3hqpryycx33dkj3cz8kwzn2w31kvldfl1q";
  };
in mkDerivation rec {
  pname = "trojita";
  version = "unstable-2020-07-06";

  src = fetchgit {
    url = "https://anongit.kde.org/trojita.git";
    rev = "e973a5169f18ca862ceb8ad749c93cd621d86e14";
    sha256 = "0r8nmlqwgsqkk0k8xh32fkwvv6iylj35xq2h8b7l3g03yc342kbn";
  };

  patches = (substituteAll {
    # See https://github.com/NixOS/nixpkgs/issues/86054
    src = ./fix-qttranslations-path.patch;
    inherit qttranslations;
  });

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
    pkg-config
    qttools
    gnupg
  ];

  postPatch = "echo ${version} > src/trojita-version"
    + lib.optionalString withI18n ''
    mkdir -p po
    for f in `find ${l10n} -name "trojita_common.po"`; do
      cp $f po/trojita_common_$(echo $f | cut -d/ -f5).po
    done
  '';

  meta = with lib; {
    description = "A Qt IMAP e-mail client";
    homepage = "http://trojita.flaska.net/";
    license = with licenses; [ gpl2 gpl3 ];
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };

}
