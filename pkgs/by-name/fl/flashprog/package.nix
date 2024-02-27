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
, withGpio ? stdenv.isLinux
}:

stdenv.mkDerivation {
  pname = "flashprog";
  version = "1.0.1";

  src = fetchgit {
    url = "https://review.sourcearcade.org/flashprog";
    rev = "2ca11f9a4101ea230081d448ab2b570425b7f0bd";
    hash = "sha256-pm9g9iOJAKnzzY9couzt8RmqZFbIpKcO++zsUJ9o49U=";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];
  buildInputs = [
    libftdi1
    libusb1
  ] ++ lib.optionals (!stdenv.isDarwin) [
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
      "CONFIG_ENABLE_LIBPCI_PROGRAMMERS=${yesNo (!stdenv.isDarwin)}"
      "CONFIG_INTERNAL_X86=${yesNo (!(stdenv.isDarwin) && stdenv.isx86_64)}"
      "CONFIG_INTERNAL_DMI=${yesNo (!(stdenv.isDarwin) && stdenv.isx86_64)}"
      "CONFIG_RAYER_SPI=${yesNo (!(stdenv.isDarwin) && stdenv.isx86_64)}"
    ];

  meta = with lib; {
    homepage = "https://flashprog.org";
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.all;
    mainProgram = "flashprog";
  };
}
