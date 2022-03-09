{ mkDerivation
, lib
, fetchFromGitLab
, pkg-config
, cmake
, cmark
, extra-cmake-modules
, kconfig
, kdbusaddons
, ki18n
, kirigami2
, kitemmodels
, knotifications
, kquickimageedit
, libpulseaudio
, libquotient
, libsecret
, olm
, qqc2-desktop-style
, qtgraphicaleffects
, qtkeychain
, qtmultimedia
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "neochat";
  version = "1.2";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "network";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Kpv7BY/qS0A3xFlYFhz1RRNwQVsyhOTHHGDbWRTTv1I=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config ];

  buildInputs = [
    cmark
    kconfig
    kdbusaddons
    ki18n
    kirigami2
    kitemmodels
    knotifications
    kquickimageedit
    libpulseaudio
    libquotient
    libsecret
    olm
    qtgraphicaleffects
    qtkeychain
    qtmultimedia
    qtquickcontrols2
    qqc2-desktop-style
  ];

  meta = with lib; {
    description = "A client for matrix, the decentralized communication protocol.";
    homepage = "https://apps.kde.org/en/neochat";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux;
  };
}
