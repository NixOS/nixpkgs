{
  fetchurl,
  stdenv,
  bash-completion,
  cmocka,
  lib,
  libftdi1,
  libjaylink,
  libusb1,
  meson,
  ninja,
  pciutils,
  pkg-config,
  sphinx,
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
    meson
    ninja
    pkg-config
    sphinx
    bash-completion
  ];
  buildInputs =
    [
      cmocka
      libftdi1
      libusb1
    ]
    ++ lib.optionals (!stdenv.isDarwin) [ pciutils ]
    ++ lib.optional jlinkSupport libjaylink;

  postPatch = ''
    substituteInPlace util/flashrom_udev.rules \
      --replace 'GROUP="plugdev"' 'TAG+="uaccess", TAG+="udev-acl"'
  '';

  postInstall = ''
    install -Dm644 $NIX_BUILD_TOP/$sourceRoot/util/flashrom_udev.rules $out/lib/udev/rules.d/flashrom.rules
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
