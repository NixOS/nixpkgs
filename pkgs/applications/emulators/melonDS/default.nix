{ lib
, fetchFromGitHub
, stdenv
, cmake
, extra-cmake-modules
, libarchive
, libpcap
, libslirp
, pkg-config
, qtbase
, qtmultimedia
, SDL2
, wayland
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "melonDS";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "Arisotura";
    repo = pname;
    rev = version;
    sha256 = "sha256-n4Vkxb/7fr214PgB6VFNgH1tMDgTBS/UHUQ6V4uGkDA=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    libarchive
    libslirp
    qtbase
    qtmultimedia
    SDL2
    wayland
  ];

  qtWrapperArgs = [ "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libpcap ]}" ];

  meta = with lib; {
    homepage = "http://melonds.kuribo64.net/";
    description = "Work in progress Nintendo DS emulator";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ artemist benley shamilton xfix ];
    platforms = platforms.linux;
  };
}
