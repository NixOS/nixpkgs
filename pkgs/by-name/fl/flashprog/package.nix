{
  fetchgit,
  lib,
  libftdi1,
  libgpiod,
  libjaylink,
  libusb1,
  meson,
  ninja,
  pciutils,
  pkg-config,
  stdenv,
  withJlink ? true,
  withGpio ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flashprog";
  version = "1.3";

  src = fetchgit {
    url = "https://review.sourcearcade.org/flashprog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-S+UKDtpKYenwm+zR+Bg8HHxb2Jr7mFHAVCZdZTqCyRQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs =
    [
      libftdi1
      libusb1
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      pciutils
    ]
    ++ lib.optionals (withJlink) [
      libjaylink
    ]
    ++ lib.optionals (withGpio) [
      libgpiod
    ];

  meta = with lib; {
    homepage = "https://flashprog.org";
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [
      felixsinger
      funkeleinhorn
    ];
    platforms = platforms.all;
    mainProgram = "flashprog";
  };
})
