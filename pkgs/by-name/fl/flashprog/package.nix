{ fetchgit
, installShellFiles
, lib
, libftdi1
, libgpiod_1
, libjaylink
, libusb1
, pciutils
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
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
    libjaylink
    libusb1
  ] ++ lib.optionals (!stdenv.isDarwin) [
    libgpiod_1
    pciutils
  ];

  makeFlags = [ "PREFIX=$(out)" "libinstall" ]
    ++ lib.optionals stdenv.isDarwin [ "CONFIG_ENABLE_LIBPCI_PROGRAMMERS=no" ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [ "CONFIG_INTERNAL_X86=no" "CONFIG_INTERNAL_DMI=no" "CONFIG_RAYER_SPI=0" ];

  meta = with lib; {
    homepage = "https://flashprog.org";
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = with licenses; [ gpl2 gpl2Plus ];
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.all;
    mainProgram = "flashprog";
  };
}
