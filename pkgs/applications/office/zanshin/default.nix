{
  mkDerivation, lib,
  fetchurl,
  extra-cmake-modules,
  qtbase, boost,
  akonadi-calendar, akonadi-notes, akonadi-search, kidentitymanagement, kontactinterface, kldap,
  krunner, kwallet, kcalendarcore
}:

mkDerivation rec {
  pname = "zanshin";
  version = "0.5.71";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0b316ddcd46sawva84x5d8nsp19v66gbm83djrra7fv3k8nkv4xh";
  };

  nativeBuildInputs = [
    extra-cmake-modules
  ];

  buildInputs = [
    qtbase boost
    akonadi-calendar akonadi-notes akonadi-search kidentitymanagement kontactinterface kldap
    krunner kwallet kcalendarcore
  ];

  meta = with lib; {
    description = "A powerful yet simple application to manage your day to day actions, getting your mind like water";
    homepage = https://zanshin.kde.org/;
    maintainers = with maintainers; [ zraexy ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
