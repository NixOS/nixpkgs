{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
  udev,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hidapi";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "libusb";
    repo = "hidapi";
    rev = "hidapi-${finalAttrs.version}";
    sha256 = "sha256-CR9aeSszuBOdLJAKLCksOcLhBjeqP8lqoamUOsak7dU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libusb1
    udev
  ];

  enableParallelBuilding = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Library for communicating with USB and Bluetooth HID devices";
    homepage = "https://github.com/libusb/hidapi";
    maintainers = with lib.maintainers; [ prusnak ];
    # You can choose between GPLv3, BSD or HIDAPI license (even more liberal)
    license =
      with lib.licenses;
      OR [
        bsd3
        gpl3Only
      ];
    pkgConfigModules =
      lib.optionals stdenv.hostPlatform.isDarwin [
        "hidapi"
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        "hidapi-hidraw"
        "hidapi-libusb"
      ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
