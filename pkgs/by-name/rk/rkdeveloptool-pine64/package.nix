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
  rev = "cce7d2a5c4efd4e7727c440868141229354b327b";
in
stdenv.mkDerivation {
  pname = "rkdeveloptool";
  version = "unstable-2021-09-04";

  src = fetchurl {
    url = "https://gitlab.com/pine64-org/quartz-bsp/rkdeveloptool/-/archive/${rev}/rkdeveloptool-${rev}.tar.gz";
    sha256 = "sha256-u/x1Y1zZ19SYwNLVAvpqjH247RijyDJ1HTDWIsmqlFk=";
  };

  postPatch = ''
    substituteInPlace meson.build --replace \
      "udev_rules_dir = udev.get_pkgconfig_variable('udevdir') + '/rules.d'" \
      "udev_rules_dir = '$out/lib/udev'"
  '';

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    scdoc
  ];

  buildInputs = [ libusb1 ];

  meta =
    let
      inherit (lib) maintainers;
    in
    {
      homepage = "https://gitlab.com/pine64-org/quartz-bsp/rkdeveloptool/";
      description = "Tool from Rockchip to communicate with Rockusb devices (pine64 fork)";
      license = lib.licenses.gpl2Only;
      maintainers = [ maintainers.adisbladis ];
      mainProgram = "rkdeveloptool";
    };
}
