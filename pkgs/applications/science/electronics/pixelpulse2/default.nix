{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libsmu
, libusb
, qt5
}:

stdenv.mkDerivation rec {
  pname = "pixelpulse2";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "pixelpulse2";
    rev = "refs/tags/v${version}";
    hash = "sha256-yzkbUi8tsxpcqnz2DynB1x4Lmhe8ZlFGg1px7F98148=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsmu
    libusb
    qt5.qtbase
    qt5.qtgraphicaleffects
  ];

  meta = with lib; {
    description = "Pixelpulse2 is a user interface for analog systems exploration";
    longDescription = "Add libsmu to services.udev.packages if you want to run this without root";
    homepage = "https://wiki.analog.com/university/tools/m1k/overview";
    license = licenses.mpl20;
    maintainers = with maintainers; [ evils ];
    platforms = platforms.unix;
  };
}
