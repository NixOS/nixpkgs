{ mkDerivation
, lib
, fetchurl
, fetchpatch
, extra-cmake-modules
, qtbase
, boost
, akonadi-calendar
, akonadi-notes
, akonadi-search
, kidentitymanagement
, kontactinterface
, kldap
, krunner
, kwallet
, kcalendarcore
}:

mkDerivation rec {
  pname = "zanshin";
  version = "0.5.71";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0b316ddcd46sawva84x5d8nsp19v66gbm83djrra7fv3k8nkv4xh";
  };

  patches = [
    # Build with kontactinterface >= 5.14.42.
    # Remove after next release.
    (fetchpatch {
      url = "https://invent.kde.org/pim/zanshin/-/commit/4850c08998b33b37af99c3312d193b063b3e8174.diff";
      sha256 = "sha256:0lh0a035alhmws3zyfnkb814drq5cqxvzpwl4g1g5d435gy8k4ps";
    })
  ];

  nativeBuildInputs = [
    extra-cmake-modules
  ];

  buildInputs = [
    qtbase
    boost
    akonadi-calendar
    akonadi-notes
    akonadi-search
    kidentitymanagement
    kontactinterface
    kldap
    krunner
    kwallet
    kcalendarcore
  ];

  meta = with lib; {
    description = "A powerful yet simple application to manage your day to day actions, getting your mind like water";
    homepage = "https://zanshin.kde.org/";
    maintainers = with maintainers; [ zraexy ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
