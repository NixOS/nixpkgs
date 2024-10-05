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

stdenv.mkDerivation (finalAttrs: {
  pname = "rpicam-apps";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "rpicam-apps";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3NG2ZE/Ub3lTbfne0LCXuDgLGTPaAAADRdElEbZwvls=";
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
    homepage = "https://github.com/raspberrypi/rpicam-apps";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jpds ];
    platforms = platforms.linux;
  };
})
