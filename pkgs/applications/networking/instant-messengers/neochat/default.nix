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
, kio
, kirigami2
, kitemmodels
, knotifications
, kquickimageedit
, libpulseaudio
, libquotient
, libsecret
, olm
, qcoro
, qqc2-desktop-style
, qtgraphicaleffects
, qtkeychain
, qtmultimedia
, qtquickcontrols2
, sonnet
}:

mkDerivation rec {
  pname = "neochat";
  version = "22.02";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "network";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7EBnHuwpyJ/bGrCldZHWOwcnJWDIDaNWZXHkCYkOTjs=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config ];

  buildInputs = [
    cmark
    kconfig
    kdbusaddons
    kio
    ki18n
    kirigami2
    kitemmodels
    knotifications
    kquickimageedit
    libpulseaudio
    libquotient
    libsecret
    olm
    qcoro
    qtgraphicaleffects
    qtkeychain
    qtmultimedia
    qtquickcontrols2
    qqc2-desktop-style
    sonnet
  ];

  meta = with lib; {
    description = "A client for matrix, the decentralized communication protocol.";
    homepage = "https://apps.kde.org/en/neochat";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux;
  };
}
