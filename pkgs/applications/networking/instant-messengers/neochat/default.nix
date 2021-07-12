{ mkDerivation
, lib
, fetchFromGitLab
, pkg-config
, cmake
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
  version = "1.1.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "network";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HvLPsU+fxlyPDP7i9OSnZ/C1RjouOQCp+4WCl6FlFJo=";
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
