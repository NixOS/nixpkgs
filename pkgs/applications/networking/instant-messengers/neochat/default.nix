{ mkDerivation
, lib, stdenv
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
  version = "1.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "network";
    repo = pname;
    rev = "v${version}";
    sha256 = "1r9n83kvc5v215lzmzh6hyc5q9i3w6znbf508qk0mdwdzxz4zry9";
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
