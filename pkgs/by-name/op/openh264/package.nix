{
  lib,
  fetchFromGitHub,
  fetchpatch,
  gtest,
  meson,
  nasm,
  ninja,
  pkg-config,
  stdenv,
  windows,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openh264";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "openh264";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tf0lnxATCkoq+xRti6gK6J47HwioAYWnpEsLGSA5Xdg=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # https://github.com/cisco/openh264/pull/3867
    (fetchpatch {
      name = "freebsd-configure.patch";
      url = "https://github.com/cisco/openh264/commit/ea8a1ad5791ee5c4e2ecf459aec235128d69b35b.patch";
      hash = "sha256-pJvh9eRxFZQ+ob4WPu/x+jr1CCpgnug1uBViLfAtBDg=";
    })
  ];

  nativeBuildInputs = [
    meson
    nasm
    ninja
    pkg-config
  ];

  buildInputs = [
    gtest
  ]
  ++ lib.optionals stdenv.hostPlatform.isWindows [
    windows.pthreads
  ];

  strictDeps = true;

  meta = {
    homepage = "https://www.openh264.org";
    description = "Codec library which supports H.264 encoding and decoding";
    changelog = "https://github.com/cisco/openh264/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ ];
    # See meson.build
    platforms =
      lib.platforms.windows
      ++ lib.intersectLists (
        lib.platforms.x86
        ++ lib.platforms.arm
        ++ lib.platforms.aarch64
        ++ lib.platforms.loongarch64
        ++ lib.platforms.riscv64
        ++ lib.platforms.power
      ) lib.platforms.unix;
  };
})
