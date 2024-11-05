{ fetchgit
, installShellFiles
, lib
, libftdi1
, libgpiod
, libjaylink
, libusb1
, pciutils
, pkg-config
, stdenv
, withJlink ? true
, withGpio ? stdenv.hostPlatform.isLinux
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flashprog";
  version = "1.2";

  src = fetchgit {
    url = "https://review.sourcearcade.org/flashprog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Z09hZ4a/G3DhWCmSkPyKs7ecSFBUfez7IWWxIhH3LyI=";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];
  buildInputs = [
    libftdi1
    libusb1
  ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    pciutils
  ] ++ lib.optionals (withJlink) [
    libjaylink
  ] ++ lib.optionals (withGpio) [
    libgpiod
  ];

  makeFlags =
    let
      yesNo = flag: if flag then "yes" else "no";
    in
    [
      "libinstall"
      "PREFIX=$(out)"
      "CONFIG_JLINK_SPI=${yesNo withJlink}"
      "CONFIG_LINUX_GPIO_SPI=${yesNo withGpio}"
      "CONFIG_ENABLE_LIBPCI_PROGRAMMERS=${yesNo (!stdenv.hostPlatform.isDarwin)}"
      "CONFIG_INTERNAL_X86=${yesNo (!(stdenv.hostPlatform.isDarwin) && stdenv.hostPlatform.isx86_64)}"
      "CONFIG_INTERNAL_DMI=${yesNo (!(stdenv.hostPlatform.isDarwin) && stdenv.hostPlatform.isx86_64)}"
      "CONFIG_RAYER_SPI=${yesNo (!(stdenv.hostPlatform.isDarwin) && stdenv.hostPlatform.isx86_64)}"
    ];

  meta = with lib; {
    homepage = "https://flashprog.org";
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ felixsinger funkeleinhorn ];
    platforms = platforms.all;
    mainProgram = "flashprog";
  };
})
