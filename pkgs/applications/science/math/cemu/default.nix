{ fetchFromGitHub
, lib
, SDL2
, libGL
, libarchive
, libusb-compat-0_1
, qtbase
, qmake
, git
, libpng_apng
, pkg-config
, wrapQtAppsHook
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "CEmu";
  version = "1.3";
  src = fetchFromGitHub {
    owner = "CE-Programming";
    repo = "CEmu";
    rev = "v${version}";
    sha256 = "1wcdnzcqscawj6jfdj5wwmw9g9vsd6a1rx0rrramakxzf8b7g47r";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qmake
    git
    wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    SDL2
    libGL
    libarchive
    libusb-compat-0_1
    qtbase
    libpng_apng
  ];

  qmakeFlags = [
    "gui/qt"
    "CONFIG+=ltcg"
  ];

  meta = with lib; {
    changelog = "https://github.com/CE-Programming/CEmu/releases/tag/v${version}";
    description = "Third-party TI-84 Plus CE / TI-83 Premium CE emulator, focused on developer features";
    homepage = "https://ce-programming.github.io/CEmu";
    license = licenses.gpl3;
    maintainers = with maintainers; [ luc65r ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    broken = stdenv.isDarwin;
  };
}
