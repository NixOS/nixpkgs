{
  mkDerivation, lib,
  fetchurl, fetchpatch,
  extra-cmake-modules,
  qtbase, boost,
  akonadi-calendar, akonadi-notes, akonadi-search, kidentitymanagement, kontactinterface, kldap,
  krunner, kwallet
}:

mkDerivation rec {
  pname = "zanshin";
  version = "0.4.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://files.kde.org/${pname}/${name}.tar.bz2";
    sha256 = "1llqm4w4mhmdirgrmbgwrpqyn47phwggjdghf164k3qw0bi806as";
  };

  patches = [
    (fetchpatch {
      name = "zanshin-fix-qt59-build.patch";
      url = "https://phabricator.kde.org/R4:77ad64872f69ad9f7abe3aa8e103a12b95e100a4?diff=1";
      sha256 = "0p497gqd3jmhbmqzh46zp6zwf6j1q77a9jp0in49xhgc2kj5ar7x";
    })
  ];

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
