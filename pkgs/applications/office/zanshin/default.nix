{
  mkDerivation, lib,
  fetchFromGitHub,
  extra-cmake-modules,
  qtbase, boost,
  akonadi-calendar, akonadi-notes, akonadi-search, kidentitymanagement, kontactinterface, kldap,
  krunner, kwallet
}:

mkDerivation rec {
  pname = "zanshin";
  version = "2017-11-25";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "zanshin";
    rev = "3df91dd81682d2ccfe542c4582dc1d5f98537c89";
    sha256 = "18wx7bdqzp81xmwi266gphh2lfbcp5s0fzyp654gki40yhkqph6m";
  };

  nativeBuildInputs = [
    extra-cmake-modules
  ];

  buildInputs = [
    qtbase boost
    akonadi-calendar akonadi-notes akonadi-search kidentitymanagement kontactinterface kldap
    krunner kwallet
  ];

  meta = with lib; {
    description = "A powerful yet simple application to manage your day to day actions, getting your mind like water";
    homepage = https://zanshin.kde.org/;
    maintainers = with maintainers; [ zraexy ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
