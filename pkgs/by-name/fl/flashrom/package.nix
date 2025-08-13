{
  fetchurl,
  stdenv,
  bash-completion,
  cmocka,
  lib,
  libftdi1,
  libjaylink,
  libusb1,
  openssl,
  meson,
  ninja,
  pciutils,
  pkg-config,
  sphinx,
  jlinkSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flashrom";
  version = "1.6.0";

  src = fetchurl {
    url = "https://download.flashrom.org/releases/flashrom-v${finalAttrs.version}.tar.xz";
    hash = "sha256-i52zmH35tfyB5wGJ0BeQXdX2vh4UEDR/Imh6ttTJRCM=";
  };

  patches = [
    # Release notes for 1.4.0 state that Promontory chipsets are unsupported, and that attempting to read flash on those systems may crash the system.
    # The patch that removes this (broken) support only made it into the 1.3.0 release, seemingly by mistake, and the relevant code has been essentially untouched since.
    # We cherry-pick the upstream patch from 1.3.0, though amended to reference the relevant bug in the error message, rather than requesting the user email upstream.
    # https://ticket.coreboot.org/issues/370
    # https://review.coreboot.org/c/flashrom/+/68824
    ./0001-sb600spi.c-Drop-Promontory-support.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    sphinx
    bash-completion
  ];
  buildInputs = [
    openssl
    cmocka
    libftdi1
    libusb1
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ pciutils ]
  ++ lib.optional jlinkSupport libjaylink;

  postPatch = ''
    substituteInPlace util/flashrom_udev.rules \
      --replace 'GROUP="plugdev"' 'TAG+="uaccess", TAG+="udev-acl"'
  '';

  mesonFlags = [
    (lib.mesonOption "programmer" "auto")
    (lib.mesonEnable "man-pages" true)
    (lib.mesonEnable "tests" (!stdenv.buildPlatform.isDarwin))
    (lib.mesonEnable "generate_authors_list" false)
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;
  doInstallCheck = true;

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
})
