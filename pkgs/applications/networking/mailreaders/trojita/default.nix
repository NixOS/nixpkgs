{
  akonadi-contacts,
  cmake,
  fetchFromGitLab,
  fetchsvn,
  gnupg,
  gpgme,
  kcontacts,
  kf5gpgmepp,
  lib,
  libsecret,
  mimetic,
  mkDerivation,
  pkg-config,
  qgpgme,
  qtbase,
  qtkeychain,
  qttools,
  qtwebkit,
  withI18n ? false,
}:

let
  l10n = fetchsvn {
    url = "svn://anonsvn.kde.org/home/kde/trunk/l10n-kf5";
    rev = "1566642";
    sha256 = "0y45fjib153za085la3hqpryycx33dkj3cz8kwzn2w31kvldfl1q";
  };
in
mkDerivation rec {
  pname = "trojita";
  version = "unstable-2022-08-22";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "pim";
    repo = "trojita";
    rev = "91087933c5e7a03a8097c0ffe5f7289abcfc123b";
    sha256 = "sha256-15G9YjT3qBKbeOKfb/IgXOO+DaJaTULP9NJn/MFYZS8=";
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
    pkg-config
    qttools
    gnupg
  ];

  postPatch =
    "echo ${version} > src/trojita-version"
    + lib.optionalString withI18n ''
      mkdir -p po
      for f in `find ${l10n} -name "trojita_common.po"`; do
        cp $f po/trojita_common_$(echo $f | cut -d/ -f5).po
      done
    '';

  meta = with lib; {
    description = "Qt IMAP e-mail client";
    homepage = "http://trojita.flaska.net/";
    license = with licenses; [
      gpl2
      gpl3
    ];
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };

}
