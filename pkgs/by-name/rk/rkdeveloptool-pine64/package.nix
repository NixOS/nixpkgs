{
  lib,
  stdenv,
  fetchurl,
  meson,
  pkg-config,
  libusb1,
  scdoc,
  ninja,
  cmake,
}:

let
  rev = "17823e99898131a234ccdb39ad114dbaeebb7fc3";
in
stdenv.mkDerivation {
  pname = "rkdeveloptool";
  version = "unstable-2021-09-04";

  src = fetchurl {
    url = "https://gitlab.com/pine64-org/quartz-bsp/rkdeveloptool/-/archive/${rev}/rkdeveloptool-${rev}.tar.gz";
    hash = "sha256-KbNjuRb6/FTTInxXVYVTtCfEKZJC/aBdtkZDkDu+rKE=";
  };

  postPatch = ''
    substituteInPlace meson.build --replace \
      "udev_rules_dir = udev.get_pkgconfig_variable('udevdir') + '/rules.d'" \
      "udev_rules_dir = '$out/lib/udev/rules.d'"
  '';

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    scdoc
  ];

  buildInputs = [ libusb1 ];

  meta = {
    homepage = "https://gitlab.com/pine64-org/quartz-bsp/rkdeveloptool/";
    description = "Tool from Rockchip to communicate with Rockusb devices (pine64 fork)";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    mainProgram = "rkdeveloptool";
  };
}
