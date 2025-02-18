{
  fetchgit,
  fetchpatch,
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

  patches = [
    # fixes compiler warnings on Darwin
    (fetchpatch {
      url = "https://review.sourcearcade.org/changes/flashprog~309/revisions/2/patch?download";
      hash = "sha256-eiEenR8+CHCJcNx9YY09I7gxRGUQWmaQlmXtykvXyMU=";
      decode = "base64 -d";
    })
  ];

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

  postInstall = ''
    cd "$src"
    install -Dm644 util/50-flashprog.rules "$out/lib/udev/rules.d/50-flashprog.rules"
  '';

  meta = with lib; {
    homepage = "https://flashprog.org";
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [
      felixsinger
      funkeleinhorn
    ];
    platforms = platforms.all;
    mainProgram = "flashprog";
  };
})
