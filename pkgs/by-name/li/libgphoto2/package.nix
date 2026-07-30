{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  autoreconfHook,
  pkg-config,
  gettext,
  libusb1,
  libtool,
  libexif,
  libgphoto2,
  libjpeg,
  curl,
  libxml2,
  gd,
}:

stdenv.mkDerivation rec {
  pname = "libgphoto2";
  version = "2.5.34";

  src = fetchFromGitHub {
    owner = "gphoto";
    repo = "libgphoto2";
    tag = "v${version}";
    hash = "sha256-+yPpoIgyXL/Qp2C4ykSlUg2BheWjzTEi6wID6yCsP/s=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    autoreconfHook
    gettext
    libtool
    pkg-config
  ];

  buildInputs = [
    libjpeg
    libtool # for libltdl
    libusb1
    curl
    libxml2
    gd
  ];

  doInstallCheck = true;

  # These are mentioned in the Requires line of libgphoto's pkg-config file.
  propagatedBuildInputs = [ libexif ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  hardeningDisable = [ "format" ];

  postInstall =
    let
      executablePrefix =
        if stdenv.buildPlatform == stdenv.hostPlatform then "$out" else buildPackages.libgphoto2;
    in
    ''
      mkdir -p $out/lib/udev/{rules.d,hwdb.d}
      ${executablePrefix}/lib/libgphoto2/print-camera-list \
          udev-rules version 201 group camera \
          >$out/lib/udev/rules.d/40-libgphoto2.rules
      ${executablePrefix}/lib/libgphoto2/print-camera-list \
          hwdb version 201 group camera \
          >$out/lib/udev/hwdb.d/20-gphoto.hwdb
    '';

  meta = {
    homepage = "http://www.gphoto.org/proj/libgphoto2/";
    changelog = "https://github.com/gphoto/libgphoto2/blob/${src.tag}/NEWS";
    description = "Library for accessing digital cameras";
    longDescription = ''
      This is the library backend for gphoto2. It contains the code for PTP,
      MTP, and other vendor specific protocols for controlling and transferring data
      from digital cameras.
    '';
    # XXX: the homepage claims LGPL, but several src files are lgpl21Plus
    license = lib.licenses.lgpl21Plus;
    platforms = with lib.platforms; unix;
    maintainers = with lib.maintainers; [ jcumming ];
  };
}
