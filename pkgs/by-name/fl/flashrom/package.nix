{
  fetchurl,
  stdenv,
  installShellFiles,
  lib,
  libftdi1,
  libjaylink,
  libusb1,
  pciutils,
  pkg-config,
  jlinkSupport ? false,
}:

stdenv.mkDerivation rec {
  pname = "flashrom";
  version = "1.4.0";

  src = fetchurl {
    url = "https://download.flashrom.org/releases/flashrom-${version}.tar.xz";
    hash = "sha256-rX7htJI5xvtPj1XjZwb81zFDXbGkvS+rPYDx9yUIzO4=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs =
    [
      libftdi1
      libusb1
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ pciutils ]
    ++ lib.optional jlinkSupport libjaylink;

  postPatch = ''
    substituteInPlace util/flashrom_udev.rules \
      --replace 'GROUP="plugdev"' 'TAG+="uaccess", TAG+="udev-acl"'
  '';

  makeFlags =
    [
      "PREFIX=$(out)"
      "libinstall"
    ]
    ++ lib.optional jlinkSupport "CONFIG_JLINK_SPI=yes"
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
      "CONFIG_INTERNAL_X86=no"
      "CONFIG_INTERNAL_DMI=no"
      "CONFIG_RAYER_SPI=no"
    ];

  postInstall = ''
    install -Dm644 util/flashrom_udev.rules $out/lib/udev/rules.d/flashrom.rules
  '';

  NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.cc.isClang && !stdenv.hostPlatform.isDarwin
  ) "-Wno-gnu-folding-constant";

  meta = with lib; {
    homepage = "https://www.flashrom.org";
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.all;
    mainProgram = "flashrom";
  };
}
