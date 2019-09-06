{
  mkDerivation, lib,
  fetchFromGitHub,
  extra-cmake-modules,
  qtbase, boost,
  akonadi-calendar, akonadi-notes, akonadi-search, kidentitymanagement, kontactinterface, kldap,
  krunner, kwallet
}:

mkDerivation {
  pname = "zanshin";
  version = "2019-07-28";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "zanshin";
    rev = "a8c223e745ed7e6aa3dd3cb0786a625a5c54e378";
    sha256 = "0jglwh30x7qrl41n3dhawn4c25dmrzscpvcajhgb6fwcl4w8cgfm";
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
