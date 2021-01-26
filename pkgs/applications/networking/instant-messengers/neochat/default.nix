{ mkDerivation
, lib
, fetchFromGitLab
, pkg-config
, cmake
, qtbase
, qttools
, qtquickcontrols2
, qtmultimedia
, qtgraphicaleffects
, qtkeychain
, libpulseaudio
, olm
, libsecret
, cmark
, extra-cmake-modules
, kirigami2
, kitemmodels
, ki18n
, knotifications
, kdbusaddons
, kconfig
, libquotient
, kquickimageedit
}:

mkDerivation rec {
  pname = "neochat";
  version = "1.0.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "network";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xGqGFJHyoZXHLv/n3UGr/KVbgs5Gc9kKKWIuKMr9DtQ=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config ];

  buildInputs = [
    qtkeychain
    qtquickcontrols2
    qtmultimedia
    qtgraphicaleffects
    olm
    libsecret
    cmark
    kirigami2
    kitemmodels
    ki18n
    knotifications
    kdbusaddons
    kconfig
    libquotient
    kquickimageedit
    libpulseaudio
  ];

  meta = with lib; {
    description = "A client for matrix, the decentralized communication protocol.";
    homepage = "https://apps.kde.org/en/neochat";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mjlbach peterhoeg ];
    platforms = with platforms; linux;
  };
}
