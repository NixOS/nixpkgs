{ stdenv
, fetchFromGitHub
, lib
, meson
, ninja
, pkg-config
, boost
, ffmpeg
, libcamera
, libdrm
, libexif
, libjpeg
, libpng
, libtiff
}:

stdenv.mkDerivation rec {
  pname = "libcamera-apps";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IRHCM8RpszSDH44Ztkf0J1LUwvX8D3qxQ/4KLiL/fn0=";
  };

  buildInputs = [
    boost
    ffmpeg
    libcamera
    libdrm
    libexif
    libjpeg
    libpng
    libtiff
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  # Meson is no longer able to pick up Boost automatically.
  # https://github.com/NixOS/nixpkgs/issues/86131
  BOOST_INCLUDEDIR = "${lib.getDev boost}/include";
  BOOST_LIBRARYDIR = "${lib.getLib boost}/lib";

  meta = with lib; {
    description = "Small suite of libcamera-based apps that aim to copy the functionality of the existing 'raspicam' apps.";
    homepage = "https://github.com/raspberrypi/libcamera-apps";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jpds ];
    platforms = platforms.linux;
  };
}
