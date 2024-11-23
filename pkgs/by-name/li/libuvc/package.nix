{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation rec {
  pname = "libuvc";
  version = "unstable-2020-11-29";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "5cddef71b17d41f7e98875a840c50d9704c3d2b2";
    sha256 = "0kranb0x1k5qad8rwxnn1w9963sbfj2cfzdgpfmlivb04544m2j7";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ libusb1 ];

  meta = with lib; {
    homepage = "https://ken.tossell.net/libuvc/";
    description = "Cross-platform library for USB video devices";
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ prusnak ];
  };
}
