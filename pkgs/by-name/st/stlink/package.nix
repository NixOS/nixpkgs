{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libusb1,
  gtk3,
  pkg-config,
  wrapGAppsHook3,
  withGUI ? false,
}:

let
  # The Darwin build of stlink explicitly refers to static libusb.
  libusb1' =
    if stdenv.hostPlatform.isDarwin then libusb1.override { withStatic = true; } else libusb1;

  # IMPORTANT: You need permissions to access the stlink usb devices.
  # Add services.udev.packages = [ pkgs.stlink ] to your configuration.nix

in
stdenv.mkDerivation rec {
  pname = "stlink";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "stlink-org";
    repo = "stlink";
    rev = "v${version}";
    sha256 = "sha256-hlFI2xpZ4ldMcxZbg/T5/4JuFFdO9THLcU0DQKSFqrw=";
  };

  patches = [
    (fetchpatch {
      name = "calloc-argument-order.patch";
      url = "https://github.com/stlink-org/stlink/commit/6a6718b3342b6c5e282a4e33325b9f97908a0692.patch";
      includes = [ "src/stlink-lib/chipid.c" ];
      sha256 = "sha256-sAfcrDdoKy5Gl1o/PHEUr8uL9OBq0g1nfRe7Y0ijWAM=";
    })
  ];

  buildInputs = [
    libusb1'
  ]
  ++ lib.optionals withGUI [
    gtk3
  ];
  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals withGUI [
    pkg-config
    wrapGAppsHook3
  ];

  doInstallCheck = true;

  cmakeFlags = [
    "-DSTLINK_MODPROBED_DIR=${placeholder "out"}/etc/modprobe.d"
    "-DSTLINK_UDEV_RULES_DIR=${placeholder "out"}/lib/udev/rules.d"
  ];

  meta = with lib; {
    description = "In-circuit debug and programming for ST-Link devices";
    license = licenses.bsd3;
    platforms = platforms.unix;
    badPlatforms = platforms.darwin;
    maintainers = [
      maintainers.bjornfor
      maintainers.rongcuid
    ];
  };
}
